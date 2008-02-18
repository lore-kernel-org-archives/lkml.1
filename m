Return-Path: <linux-kernel-owner+w=401wt.eu-S1757628AbYBRXhU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757628AbYBRXhU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 18:37:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752891AbYBRXhH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 18:37:07 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:46592 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbYBRXhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 18:37:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:bcc:subject:reply-to:in-reply-to:message-id;
        b=Yz0intdmOCHkUoGfynyrCQPCBmq/CQbCK7PWWh9LFIU4WZvdgMKhtKc/6QksVlFc7hwO8kZ1S5BTFoGiGsVWcBiObB1g7SLH4aK5Lv5bEBy1sbfoqNGhYALyamza21l2mSnkFN3zAn/pRTDJQsPD0gP7GwkeC8DPCJXAmbvgj9U=
Date: Mon, 18 Feb 2008 15:45:12 -0800
From: Glenn Griffin <ggriffin.kernel@gmail.com>
To: ggriffin.kernel@gmail.com
Cc: dada1@cosmosbay.com, johnpol@2ka.mipt.ru, alan@lxorguk.ukuu.org.uk,
       andi@firstfloor.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, yoshfuji@linux-ipv6.org
Subject: Re: [PATCH] Add IPv6 support to TCP SYN cookies
In-Reply-To: <20080212.030741.132208013.yoshfuji@linux-ipv6.org>
Message-ID: <47ba169f.23f8720a.54d4.0229@mx.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've posted a series of patches that I believe address Andi's concerns
about syncookies not supporting valuable tcp options (primarily SACK,
and window scaling).  The premise being if the client support tcp
timestamps we can encode the additional tcp options in the initial
timestamp we send back to the client, and they will be echo'd back to us
in the ack.  Anyone interested have a look, and provide any suggestions
you may have.  The new patches are a superset of this patch, so if they
are accepted this is one obsolete.

Support arbitrary initial TCP timestamps
http://lkml.org/lkml/2008/2/15/244

Enable the use of TCP options with syncookies
http://lkml.org/lkml/2008/2/15/245

Add IPv6 Support to TCP SYN cookies
http://lkml.org/lkml/2008/2/15/246

--Glenn
