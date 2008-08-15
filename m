Return-Path: <linux-kernel-owner+w=401wt.eu-S1755367AbYHOBtk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755367AbYHOBtk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 21:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752512AbYHOBtb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 21:49:31 -0400
Received: from xenotime.net ([66.160.160.81]:52031 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752499AbYHOBt3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 21:49:29 -0400
Date: Thu, 14 Aug 2008 18:49:48 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Aivils Stoss <aivils@latnet.lv>, lud <linux-usb@vger.kernel.org>
Cc: Samuel Thibault <samuel.thibault@ens-lyon.org>,
       linux-input@vger.kernel.org, jkosina@suse.cz,
       linux-kernel@vger.kernel.org, linuxconsole-dev@lists.sourceforge.net
Subject: Re: PROBLEM: USB keyboards works only 4 per PC host port
Message-Id: <20080814184948.093d2cad.rdunlap@xenotime.net>
In-Reply-To: <200808100408.37473.aivils@latnet.lv>
References: <200808080702.24969.aivils@latnet.lv>
	<20080809104226.GF4546@implementation>
	<200808100408.37473.aivils@latnet.lv>
Organization: YPO4
X-Mailer: Sylpheed 2.5.0 (GTK+ 2.12.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="Multipart=_Thu__14_Aug_2008_18_49_48_-0700_NLUsxwZgbXZeG6Wo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--Multipart=_Thu__14_Aug_2008_18_49_48_-0700_NLUsxwZgbXZeG6Wo
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On Sun, 10 Aug 2008 04:08:37 +0100 Aivils Stoss wrote:

> On Saturday 09 August 2008 11:42:26 am Samuel Thibault wrote:
> > Aivils Stoss, le Fri 08 Aug 2008 07:02:24 +0100, a =E9crit :
> > > I suppose this is Linux kernel bug because i test keyboards under
> > > Windows, which support any schema of cascading of usb hubs.
> >
> > On the very same machine and hubs?
>=20
> Yes, on same machine. Under Windows i don't have evdev interface,
> checked only how keypress go to console.
> Of course to repeat a try You must have at least 5 keyboards and
> 1 7-port or 2 4-port hubs and kernel 2.6.22 and above. I allways
> got result - 5th, 6th, 7th keyboard does not send events to console
> or evdev.


[adding linux-usb mailing list]

Hi,

I finally got 5 USB keyboards together along with 2 hubs.
I daisy-chained the hubs and connected 1 keyboard to the hub that is
on the notebook computer USB port, then I connected 4 keyboards to the
second hub.  They all worked for me, meaning that I can type on all of
them and have their characters show up on my console.

I'm testing with 2.6.7-rc2.
'usbtree' output of the USB subsystem is attached.


---
~Randy
Linux Plumbers Conference, 17-19 September 2008, Portland, Oregon USA
http://linuxplumbersconf.org/

--Multipart=_Thu__14_Aug_2008_18_49_48_-0700_NLUsxwZgbXZeG6Wo
Content-Type: text/plain;
 name="usb-kbds.txt"
Content-Disposition: attachment;
 filename="usb-kbds.txt"
Content-Transfer-Encoding: quoted-printable

/: Bus 05.Port 1: Dev 1, Class=3Droot_hub, Drv=3Duhci_hcd/2p, 12M
/: Bus 04.Port 1: Dev 1, Class=3Droot_hub, Drv=3Duhci_hcd/2p, 12M
    |_ Port 1: Dev 2, If 0, Prod=3DMicrosoft IntelliMouse=AE Explorer, Clas=
s=3DHID, Drv=3Dusbhid, 1.5M
    |_ Port 2: Dev 3, If 0, Prod=3DGeneric USB Hub, Class=3Dhub, Drv=3Dhub/=
4p, 12M
        |_ Port 1: Dev 8, If 0, Prod=3DMobility USB EasiDock 200, Class=3Dh=
ub, Drv=3Dhub/9p, 12M
            |_ Port 1: Dev 17, If 0, Prod=3DAPI USB KB HUB, Class=3Dhub, Dr=
v=3Dhub/3p, 12M
                |_ Port 1: Dev 18, If 0, Prod=3DAPI USB KB HUB, Class=3DHID=
, Drv=3Dusbhid, 12M
                |_ Port 2: Dev 19, If 0, Prod=3D, Class=3DHID, Drv=3Dusbhid=
, 1.5M
            |_ Port 2: Dev 14, If 0, Prod=3DUSB Keyboard, Class=3DHID, Drv=
=3Dusbhid, 1.5M
            |_ Port 2: Dev 14, If 1, Prod=3D, Class=3DHID, Drv=3Dusbhid, 1.=
5M
            |_ Port 3: Dev 13, If 0, Prod=3DUSB Multimedia Keyboard, Class=
=3DHID, Drv=3Dusbhid, 1.5M
            |_ Port 3: Dev 13, If 1, Prod=3D, Class=3DHID, Drv=3Dusbhid, 1.=
5M
            |_ Port 4: Dev 11, If 0, Prod=3DDell USB Keyboard Hub, Class=3D=
hub, Drv=3Dhub/3p, 12M
                |_ Port 1: Dev 12, If 0, Prod=3DDell USB Keyboard, Class=3D=
HID, Drv=3Dusbhid, 12M
                |_ Port 1: Dev 12, If 1, Prod=3D, Class=3DHID, Drv=3Dusbhid=
, 12M
            |_ Port 8: Dev 9, If 0, Prod=3DMobility PS/2 Keyboard And Mouse=
 I/F, Class=3DHID, Drv=3Dusbhid, 12M
            |_ Port 9: Dev 10, If 0, Prod=3DMobility USB Serial Converter, =
Class=3Dvend., Drv=3Dnone, 12M
        |_ Port 2: Dev 15, If 0, Prod=3DMultimedia Keyboard Hub, Class=3Dhu=
b, Drv=3Dhub/3p, 12M
            |_ Port 1: Dev 16, If 0, Prod=3DMultimedia Keyboard Hub, Class=
=3DHID, Drv=3Dusbhid, 12M
            |_ Port 1: Dev 16, If 1, Prod=3D, Class=3DHID, Drv=3Dusbhid, 12M
/: Bus 03.Port 1: Dev 1, Class=3Droot_hub, Drv=3Duhci_hcd/2p, 12M
/: Bus 02.Port 1: Dev 1, Class=3Droot_hub, Drv=3Duhci_hcd/2p, 12M
/: Bus 01.Port 1: Dev 1, Class=3Droot_hub, Drv=3Dehci_hcd/8p, 480M

--Multipart=_Thu__14_Aug_2008_18_49_48_-0700_NLUsxwZgbXZeG6Wo--
