Return-Path: <linux-kernel-owner+w=401wt.eu-S1760158AbXFSROo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760158AbXFSROo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2007 13:14:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758234AbXFSROh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jun 2007 13:14:37 -0400
Received: from web52504.mail.re2.yahoo.com ([206.190.48.187]:36680 "HELO
	web52504.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757453AbXFSROh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2007 13:14:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=fZDPN6ckjHO8uj0BrTt+qPnwxkw35Cv2mkanm5tLDfj+yLZvmbKqHlWts5+SScekjeJs4GzI3mNs4sQ7I7On9/JQCsR+jY4VR9ePlB5yvytR1IuNgSjml1rD2cG88n+qG9Ai+TcTfWvZIYJ4IeSLVrxoZ9JnM/R5slHEPNwybBI=;
X-YMail-OSG: sEZVdxQVM1mp53q9RP9qQ21Z.kFmxN2d5Qm836F6XGhLNl.5Ztb78ejKzthfEGutf2Lk2eonoytPKfjXhI2BlBw1IORWC.I7lA8T1toW5ccJlhvKFd4-
Date: Tue, 19 Jun 2007 10:14:36 -0700 (PDT)
From: Marc Perkel <mperkel@yahoo.com>
Subject: Re: How would I do this? (expert tricks) OT
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0706191852360.5731@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <256797.88744.qm@web52504.mail.re2.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Jan Engelhardt <jengelh@computergmbh.de> wrote:

> 
> On Jun 19 2007 09:48, Marc Perkel wrote:
> >
> >I have a server with port 25 closed. I was to be
> able
> >to run a script every time someone tries to connect
> to
> >port 25, but from the outside the port remains
> closed.
> >I need the script that I'm going to run get the IP
> >address that tried to connect.
> >
> >I know it's off topic but it's part of an
> experiment
> >to stop spam. 
> 
> tcpdump -lni any port 25
> iptables -p tcp --dport 25 -j NFQUEUE
> ...
> 

Thanks Jan, but I'm not sure it answers my question. I
want to run a script every time a connection attempt
is made in real time with the IP address as a
parameter to the script. How would I do that? Suppose
my script is:

iplog <ipaddress>




       
____________________________________________________________________________________
Take the Internet to Go: Yahoo!Go puts the Internet in your pocket: mail, news, photos & more. 
http://mobile.yahoo.com/go?refer=1GNXIC
