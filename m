Return-Path: <linux-kernel-owner+w=401wt.eu-S1753526AbZKOTdr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526AbZKOTdr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Nov 2009 14:33:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753427AbZKOTdq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Nov 2009 14:33:46 -0500
Received: from de01.mail.all-tld.net ([195.140.232.8]:50237 "EHLO
	de01.mail.all-tld.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327AbZKOTdq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Nov 2009 14:33:46 -0500
Date: Sun, 15 Nov 2009 20:33:29 +0100
From: Anders Larsen <al@alarsen.net>
Subject: Re: [PATCH v5 10/12] string: factorize skip_spaces and export it to
 be generally available
To: =?iso-8859-1?b?QW5kcuk=?= Goddard Rosa <andre.goddard@gmail.com>
Cc: linux list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
References: <cover.1258181836.git.andre.goddard@gmail.com>
	<b6353c59eca999d76c7951f24aae6eb890eb510b.1258181837.git.andre.goddard@gmail.com>
In-Reply-To: <b6353c59eca999d76c7951f24aae6eb890eb510b.1258181837.git.andre.goddard@gmail.com>
	(from andre.goddard@gmail.com on Sun Nov 15 08:15:03 2009)
X-Mailer: Balsa 2.3.21
Message-Id: <1258313609l.9645l.0l@oscar.alarsen.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
X-ALL-TLD-GmbH-Information: AEV Virus and Spam Secure Mail System
X-ALL-TLD-GmbH-VirusScanner: Found to be clean
X-ALL-TLD-GmbH-SpamCheck: 
X-MailScanner-From: al@alarsen.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009-11-15 08:15:03, André Goddard Rosa wrote:
> +char *skip_spaces(const char *str)
> +{
> +	while (isspace(*str))
> +		++str;
> +	return (char *)str;
> +}

Is there a good reason why the parameter 'str' is declared 'const'
when skip_spaces() returns a non-const pointer into str ?

Cheers
Anders
