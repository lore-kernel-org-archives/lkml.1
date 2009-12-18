Return-Path: <linux-kernel-owner+w=401wt.eu-S1755204AbZLRR4B@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204AbZLRR4B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Dec 2009 12:56:01 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752479AbZLRR4A
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Dec 2009 12:56:00 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:41322 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752434AbZLRRz6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Dec 2009 12:55:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=ZiMME+mY3Y3I0mS2bkU3T4T6+LFDveqx63htdsj/M1t9Xo/5uXa59xb9rNXDjyK/Ew
         SWhXvGfl28OMxVn76tz/ecbLICMZdrcE+tABC14FCKV7Ew5QQ/Bw8AEhW1NDWo1ltFHO
         CSRINfspgbHT2d4na9+destul+eSZeO4Yzmps=
MIME-Version: 1.0
In-Reply-To: <e75d22a90912171449s7262b0fag41b045526ed35091@mail.gmail.com>
References: <e75d22a90912171449s7262b0fag41b045526ed35091@mail.gmail.com>
Date: Sat, 19 Dec 2009 01:55:57 +0800
Message-ID: <9b5c9bb30912180955t78780ab2j2bccabe3160a67ef@mail.gmail.com>
Subject: Re: tg3 and bcm5703 cards - rx dropped packets
From: Teck Choon Giam <giamteckchoon@gmail.com>
To: Michael Di Domenico <mdidomenico4@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Have you try one or all of the below?

/sbin/ethtool -K eth0 tx off
/sbin/ethtool -K eth0 rx off
/sbin/ethtool -K eth0 gso off
/sbin/ethtool -K eth0 tso off

Assuming eth0 is your interface.
