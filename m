Return-Path: <linux-kernel-owner+w=401wt.eu-S1752315AbZI0S3I@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752315AbZI0S3I (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 14:29:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752131AbZI0S3H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 14:29:07 -0400
Received: from fifo99.com ([67.223.236.141]:35481 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890AbZI0S3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 14:29:06 -0400
Subject: Re: [PATCH] WARN_ONCE(): use bool for condition
From: Daniel Walker <dwalker@fifo99.com>
To: Cesar Eduardo Barros <cesarb@cesarb.net>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Roland Dreier <rolandd@cisco.com>
In-Reply-To: <1254075912-17557-1-git-send-email-cesarb@cesarb.net>
References: <4ABFAB27.1040608@cesarb.net>
	 <1254075912-17557-1-git-send-email-cesarb@cesarb.net>
Content-Type: text/plain
Date: Sun, 27 Sep 2009 11:28:28 -0700
Message-Id: <1254076108.20648.529.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2009-09-27 at 15:25 -0300, Cesar Eduardo Barros wrote:
> -               int __ret_warn_on = !!(condition);                      \
> +               bool __ret_warn_on = (condition);                       \

Did you try it without removing the "!!" ? In my original email I tested
the path of least resistance, and I left the "!!" in there..

Daniel

