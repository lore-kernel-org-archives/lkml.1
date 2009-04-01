Return-Path: <linux-kernel-owner+w=401wt.eu-S1760971AbZDAIgf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760971AbZDAIgf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Apr 2009 04:36:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754757AbZDAIgT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Apr 2009 04:36:19 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:24294 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753836AbZDAIgQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Apr 2009 04:36:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hZ79yhYjdk3Qjr/h1u2O/M6RZcM63QqUA/0Peh7DbJsTJPSVvssjh1a0HoWoUaI4XO
         QiStpi8XglNark0jWG5LQ7fe5anDiJJaY6Im2fK3CG8wAEziFQA3TFICW3uHqwSn/1zD
         BzCsLeEuBXyxkKZHVxUQ+mGxpr/x0MT12pizg=
MIME-Version: 1.0
In-Reply-To: <1238196439-16535-29-git-send-email-u.kleine-koenig@pengutronix.de>
References: <20090327232153.GA16348@pengutronix.de>
	 <1238196439-16535-29-git-send-email-u.kleine-koenig@pengutronix.de>
Date: Wed, 1 Apr 2009 14:06:14 +0530
Message-ID: <5d5443650904010136i7894b01y24393cc69f7b0234@mail.gmail.com>
Subject: Re: [PATCH 29/58] move omap24xxcam's probe function to .devinit.text
From: Trilok Soni <soni.trilok@gmail.com>
To: =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       Sakari Ailus <sakari.ailus@nokia.com>,
       Hans Verkuil <hverkuil@xs4all.nl>,
       Mauro Carvalho Chehab <mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

>
> -static int __init omap24xxcam_probe(struct platform_device *pdev)
> +static int __devinit omap24xxcam_probe(struct platform_device *pdev)
>  {
>        struct omap24xxcam_device *cam;
>        struct resource *mem;
> --
> 1.6.2
>
>

Acked-by: Trilok Soni <soni.trilok@gmail.com>

-- 
---Trilok Soni
http://triloksoni.wordpress.com
http://www.linkedin.com/in/triloksoni
