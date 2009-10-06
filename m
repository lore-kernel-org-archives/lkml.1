Return-Path: <linux-kernel-owner+w=401wt.eu-S933645AbZJFX2O@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933645AbZJFX2O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 19:28:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933612AbZJFX2N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 19:28:13 -0400
Received: from ozlabs.org ([203.10.76.45]:54316 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933443AbZJFX2N convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 19:28:13 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Uwe =?utf-8?q?Kleine-K=C3=B6nig?=" <u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 29/34] move virtballoon_remove to .devexit.text
Date: Tue, 6 Oct 2009 20:17:55 +1030
User-Agent: KMail/1.11.2 (Linux/2.6.28-15-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Michael S. Tsirkin" <mst@redhat.com>
References: <20091001082607.GA2181@pengutronix.de> <1254385718-14254-29-git-send-email-u.kleine-koenig@pengutronix.de>
In-Reply-To: <1254385718-14254-29-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200910062017.55803.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Oct 2009 05:58:33 pm Uwe Kleine-König wrote:
> The function virtballoon_remove is used only wrapped by __devexit_p so
> define it using __devexit.

Thanks, applied!

Rusty.
