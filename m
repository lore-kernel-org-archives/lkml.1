Return-Path: <linux-kernel-owner+w=401wt.eu-S1755433AbZICOmL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755433AbZICOmL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Sep 2009 10:42:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753896AbZICOmK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Sep 2009 10:42:10 -0400
Received: from mail-yw0-f188.google.com ([209.85.211.188]:43124 "EHLO
	mail-yw0-f188.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbZICOmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Sep 2009 10:42:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type;
        b=M1uvkv3BSJ1R0SGcUdRe7HuO7gwfNJUMwTmsuOsaCyixvCStNFi9PXbhmY3qneQEJ5
         y4eLboEpkQQKUx2c3+bbfDs48k7aMFXEd/TXR3iZVEOrVTraB9AaUEOpN53gsBQJr45n
         3fUxon7SGe8lpIVR44Na5VSek5g/E129SUUgs=
MIME-Version: 1.0
In-Reply-To: <8e8a9c7c0909030737g7ca5746at4bf51940ff690b36@mail.gmail.com>
References: <8e8a9c7c0909030737g7ca5746at4bf51940ff690b36@mail.gmail.com>
From: Treker Chen <treker.chen@gmail.com>
Date: Thu, 3 Sep 2009 22:41:52 +0800
Message-ID: <8e8a9c7c0909030741j63a26192m54feab96cc9fbd5a@mail.gmail.com>
Subject: Why sometimes linux kernel does not reply the ACK of second FIN 
	packet?
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all

I was wondering if anyone know sometimes linux kernel seems does not
reply the ACK to the second FIN packet?
I tried it on Linux Ubuntu804Server 2.6.24-16-server #1 SMP Thu Apr 10
13:58:00 UTC 2008 i686 GNU/Linux

and here is the tcpdump log

22:24:37.444551 IP 192.168.6.3.42049 > 192.168.6.30.22: S
880658043:880658043(0) win 5840 <mss 1000,sackOK,timestamp 405800485
0,nop,wscale 7>
22:24:37.445091 IP 192.168.6.30.22 > 192.168.6.3.42049: S
1391057992:1391057992(0) ack 880658044 win 5792 <mss
1460,sackOK,timestamp 68876023 405800485,nop,wscale 6>
22:24:37.445182 IP 192.168.6.3.42049 > 192.168.6.30.22: . ack 1 win 46
<nop,nop,timestamp 405800485 68876023>
22:24:37.453582 IP 192.168.6.30.22 > 192.168.6.3.42049: P 1:39(38) ack
1 win 91 <nop,nop,timestamp 68876024 405800485>
22:24:37.453663 IP 192.168.6.3.42049 > 192.168.6.30.22: . ack 39 win
46 <nop,nop,timestamp 405800486 68876024>
22:24:39.183281 IP 192.168.6.3.42049 > 192.168.6.30.22: P 1:3(2) ack
39 win 46 <nop,nop,timestamp 405800659 68876024>
22:24:39.183846 IP 192.168.6.30.22 > 192.168.6.3.42049: . ack 3 win 91
<nop,nop,timestamp 68876196 405800659>
22:24:39.183899 IP 192.168.6.30.22 > 192.168.6.3.42049: P 39:58(19)
ack 3 win 91 <nop,nop,timestamp 68876196 405800659>
22:24:39.183934 IP 192.168.6.3.42049 > 192.168.6.30.22: . ack 58 win
46 <nop,nop,timestamp 405800659 68876196>
22:24:39.183952 IP 192.168.6.30.22 > 192.168.6.3.42049: F 58:58(0) ack
3 win 91 <nop,nop,timestamp 68876196 405800659>
22:24:39.184636 IP 192.168.6.3.42049 > 192.168.6.30.22: F 3:3(0) ack
59 win 46 <nop,nop,timestamp 405800659 68876196>
22:24:39.185093 IP 192.168.6.30.22 > 192.168.6.3.42049: . ack 4 win 91
<nop,nop,timestamp 68876196 405800659>

you can see at the end there is only one ACK packet and sometimes it
did. does any one know the possible reason?
I am asking this because with a high traffic server, it caused lots'
of connection in TIME_WAIT state, and i was suspecting that's causing
the issue.

please kindly CC to my email address. thanks

Regards
Treker
