Return-Path: <linux-kernel-owner+w=401wt.eu-S1753101AbZGBRoD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101AbZGBRoD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 13:44:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751993AbZGBRny
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 13:43:54 -0400
Received: from rv-out-0506.google.com ([209.85.198.231]:57732 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751716AbZGBRny convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 13:43:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=JUGpdq1W8pCt4d2EsGkz07FrK4379O5QThejZUUXsYigOS+CwOBzeyDKES3ucaP9TO
         XbVgNuMqh8MoVtJTFE65Rxfc10xWTMTY7mPTF5YaexOgOaunCd+Gp6ELmKTzAPm1ivvR
         gPVwEp/VxpqEPzMJmCMm/idFELTYHAMRUecyo=
MIME-Version: 1.0
In-Reply-To: <4A4CF07B.3090600@cam.ac.uk>
References: <68FBE0F3CE97264395875AC1C468F22C152BE8@mail03.cyberswitching.local> 
	<4A4CF07B.3090600@cam.ac.uk>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Thu, 2 Jul 2009 13:43:37 -0400
Message-ID: <8bd0f97a0907021043l30a34e6dh581ea5e96130d7eb@mail.gmail.com>
Subject: Re: [lm-sensors] [PATCH] adxl345 accelerometer hwmon driver
To: Jonathan Cameron <jic23@cam.ac.uk>
Cc: Chris Verges <chrisv@cyberswitching.com>, linux-kernel@vger.kernel.org,
       lm-sensors@lm-sensors.org,
       Michael Hennerich <michael.hennerich@analog.com>,
       Robin Getz <rgetz@blackfin.uclinux.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 2, 2009 at 13:38, Jonathan Cameron wrote:
> One interesting thing I just came across whilst searching lkml for
> your post to reply to, was that Mike Frysinger submited a patch
> adding some board support for an adx34x driver to bf548-ezkit.
> I've not seen any sign of this anywhere else as yet (it hasn't
> hit the input list which would be the obvious place) I've copied in
> both people who signed off.  Michael or Mike able to give us more info?

that's because we're still in the process of making sure it is stable.
 I2C is a pita to work with.
http://git.kernel.org/?p=linux/kernel/git/vapier/blackfin.git;a=commitdiff;h=43d4cabbdeb5c24f84b159c5dc369c1a60844a48

the advantage here is that we have been testing our driver with actual
hardware ...
-mike
