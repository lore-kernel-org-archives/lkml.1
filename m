Return-Path: <linux-kernel-owner+w=401wt.eu-S1753151AbYFYTt5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753151AbYFYTt5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2008 15:49:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752448AbYFYTtp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jun 2008 15:49:45 -0400
Received: from hope.ime.usp.br ([143.107.45.8]:58651 "HELO hope.ime.usp.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752146AbYFYTto (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2008 15:49:44 -0400
Date: Wed, 25 Jun 2008 16:49:38 -0300
From: =?iso-8859-1?Q?Rog=E9rio?= Brito <rbrito@ime.usp.br>
To: Ivo van Doorn <ivdoorn@gmail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>, linux-kernel@vger.kernel.org,
       rbrito@ime.usp.br
Subject: Re: [2.6.26-rc4] Problems with rt2x00 USB interface on powerpc (fwd)
Message-ID: <20080625194937.GA13636@ime.usp.br>
References: <20080620175729.GA3151@ime.usp.br> <200806202048.47239.IvDoorn@gmail.com> <20080620195815.GA2703@ime.usp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080620195815.GA2703@ime.usp.br>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Ivo and John (again).

On Jun 20 2008, Rogério Brito wrote:
> On Jun 20 2008, Ivo van Doorn wrote:
> > 
> > > Did you receive my earlier message (attached here for reference)? I'm
> > > willing to experiment with the driver a little bit and I hope that the
> > > information that I have provided so far is helpful to chase the reason
> > > why the driver doesn't work on PowerPC.
> > 
> > Sorry I have been quite busy with other things.
> 
> I'm terribly sorry for that, since I would like the driver to work with
> the USB stick still in the 2.6.26 release (since that's what some
> distributions will probably use).

Just for your information, I just compiled the -rc7 kernel on x86-64 (where
rt2500usb works if I boot with kernel 2.6.25) and still doesn't work (I'm
not even mentioning here PowerPC).

The "doesn't work" part means that the usual procedure of bringing the
interface up, setting the key (I'm using WEP), setting the essid (at which
point it should already be associated with the AP) and then using a dchp
client on the interface doesn't get a DHCP lease.

The DHCP client just sits there trying to send a broadcast message and
there is no response. After the key is set and after the essid is set, I
see that it is not associated with the AP, even though I get messages on
dmesg that it has associated and then the association was lost (I don't
have the dmesg log here on this computer).

Interestingly, I can see the AP if I do an "iwlist wlan0 scan" command.

I would really like to help with this problem (and have it fixed) before
the actual release of 2.6.26. Since I saw that you had some activity in
your git tree.

To John: would you like me to test any other tree with my hardware, like
the wireless-next tree? Would it make any difference?


Regards, Rogério Brito.

-- 
Rogério Brito : rbrito@{mackenzie,ime.usp}.br : GPG key 1024D/7C2CAEB8
http://www.ime.usp.br/~rbrito : http://meusite.mackenzie.com.br/rbrito
Projects: algorithms.berlios.de : lame.sf.net : vrms.alioth.debian.org
