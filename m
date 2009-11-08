Return-Path: <linux-kernel-owner+w=401wt.eu-S1754602AbZKHQiH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754602AbZKHQiH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 11:38:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753478AbZKHQiG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 11:38:06 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41209 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753335AbZKHQiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 11:38:05 -0500
Subject: Re: [PATCH v4 10/12] string: factorize skip_spaces and export it
 to be generally available
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: =?ISO-8859-1?Q?Andr=E9?= Goddard Rosa <andre.goddard@gmail.com>
Cc: jengelh@medozas.de, linux-kernel@vger.kernel.org
In-Reply-To: <c7d3b02b5e28eaa54a5360d57dfd177c44320187.1257602781.git.andre.goddard@gmail.com>
References: <cover.1257602781.git.andre.goddard@gmail.com>
	 <c7d3b02b5e28eaa54a5360d57dfd177c44320187.1257602781.git.andre.goddard@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 08 Nov 2009 10:38:05 -0600
Message-Id: <1257698285.4184.10.camel@mulgrave.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2009-11-07 at 14:23 -0200, André Goddard Rosa wrote:
> + * skip_spaces - Removes leading whitespace from @s.
> + * @s: The string to be stripped.
> + *
> + * Returns a pointer to the first non-whitespace character in @s.
> + */
> +char *skip_spaces(const char *str)

OK, so this now becomes a bad interface because it silently promotes
const to non const ... and I'm sure the compiler would warn about this
too in string.c ... did this get compiled?

James


