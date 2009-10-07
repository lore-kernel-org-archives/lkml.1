Return-Path: <linux-kernel-owner+w=401wt.eu-S1760042AbZJGUxZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760042AbZJGUxZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 16:53:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760016AbZJGUxZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 16:53:25 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:38406 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760012AbZJGUxY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 16:53:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=aeMxP9g05H1HvBhvN4WgYKG2601Xc3zmjn83FR1IcH8USyVoRplybRUqKvj+zn6gQw
         hqbAj/78fJtOkvPlT/xpcH4pxAQeM4sFR/WPSAGj2lWmGdHEDA3N4qj1Eqq8qzyCpGvy
         zrvD/pmiZbPVFPuxPlp2Ztd9m+9oCDzaVJn6M=
MIME-Version: 1.0
Date: Wed, 7 Oct 2009 13:52:47 -0700
Message-ID: <296622aa0910071352v16ba4302y2c5ae50f51924026@mail.gmail.com>
Subject: Linux autobuild Makefile to assist in autobuilding the kernel (eg. 
	via a cronjob)
From: Joe moo <starquestnerd@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I hope you like it you can look at it and fork it here:
http://gist.github.com/204431

Basically it automates a lot of things and it ONLY wraps around the
current Makefile to avoid reinventing the wheel. It runs git pull to
update and (by default) builds an x86 system configured with
allmodconfig! I acctually wrote this a few months ago...
