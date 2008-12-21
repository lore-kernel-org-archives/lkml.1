Return-Path: <linux-kernel-owner+w=401wt.eu-S1752689AbYLUGRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbYLUGRy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 01:17:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751122AbYLUGRp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 01:17:45 -0500
Received: from an-out-0708.google.com ([209.85.132.250]:33064 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750921AbYLUGRo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 01:17:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=DskH1t72FYs33LzwHXnG+LAu0baWzxYOCitYEHeXevVwhUhf5OK/ds3ez6slysiYZz
         2hp0Ne+u0Hagn6ZUdzNsTrlP7rIvURHVRajIq3/+kxbBhAMNmxaemjKoVLOJ2EGdYVrf
         PNXrGW80Ycz7TOqWyW5KAYDUehQIYPDzXK5hE=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Adrian McMenamin <adrian@newgolddream.dyndns.info>
Subject: Re: [PATCH] sh: maple: Robust checking for errors on maple keyboard initialisation
Date: Sat, 20 Dec 2008 22:17:04 -0800
User-Agent: KMail/1.10.3 (Linux/2.6.27.7-134.fc10.x86_64; KDE/4.1.3; x86_64; ; )
Cc: lkmL <linux-kernel@vger.kernel.org>,
       "linux-input" <linux-input@vger.kernel.org>,
       "linux-sh" <linux-sh@vger.kernel.org>, Paul Mundt <lethal@linux-sh.org>,
       Matt Fleming <matt@console-pimps.org>, Andrew Morton <akpm@osdl.org>
References: <1229797527.6502.18.camel@localhost.localdomain>
In-Reply-To: <1229797527.6502.18.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200812202217.05002.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 20 December 2008 10:25:27 Adrian McMenamin wrote:
> As was pointed out in response to http://lkml.org/lkml/2008/12/19/373
> maple drivers were not properly checking for NULL pointers.
>
> This patch fixes this for the keyboard driver already in mainline.
>

This driver is fine as is, only the joystick driver had the issue.

-- 
Dmitry
