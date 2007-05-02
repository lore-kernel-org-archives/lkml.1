Return-Path: <linux-kernel-owner+w=401wt.eu-S2992986AbXEBJza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992986AbXEBJza (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 05:55:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992984AbXEBJza
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 05:55:30 -0400
Received: from nz-out-0506.google.com ([64.233.162.225]:44280 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992986AbXEBJz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 05:55:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=VffyjdsAV9143zf6D+aspeNlhNgb5Ye/F6kpUu6NoJAA5WDakCLQe5CGma/vVUmKumreDPQ9GSfRA/QmnqioFgqf23Fhs6suGumqNMCuoWgiSoVgkM/NruVimcJ/xNxaQZkmtDg5gD9y/c/ifIz+jf3rlMFyL+qZyc37TVuV7i0=
Message-ID: <47ed01bd0705020255x3a05cabbo955b4e980771b92@mail.gmail.com>
Date: Wed, 2 May 2007 05:55:28 -0400
From: "Dylan Taft" <d13f00l@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Strange UDP Issue on 2.6.20.8 - broadcasts not being received if socket bound to local ip
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I've been pulling my hair out for the past several hours trying to
debug a program in wine.  I'm currently on kernel 2.6.20.8.  The
problem was that I was not getting any broadcasts to 255.255.255.255
on a UDP socket bound to 192.168.0.8 with SO_BROADCAST enabled.

I was fiddling around a bit, broadcasts come in fine if the socket is
bound to INADDR_ANY( 0.0.0.0), but if it's bound to 192.168.0.8
nothing comes in.  I did a packet sniff, and indeed packets were being
sent out to 255.255.255.255 via another machine on the network.  I
wrote a quick test program that would bind a socket to the lan ip and
wait for incoming data.  I tested it on a windows machine and linux.
The windows machine could pick up packets fine, my linux machine could
not.   Is this proper behavior?  It's fudging up several games and
things in the wine project.

Does anyone else experience this?  Thanks!

Dylan Taft
