Return-Path: <linux-kernel-owner+w=401wt.eu-S932069AbYBSTB0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932069AbYBSTB0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 14:01:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754594AbYBSTBO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 14:01:14 -0500
Received: from mu-out-0910.google.com ([209.85.134.185]:23872 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755076AbYBSTBG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 14:01:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:reply-to:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:message-id;
        b=Zfsklb9pNG8oj0wUQWjREAGLgMuHjqY3IxgF8g0nW3jXhbmQG4NsMyetOWGNmkhgLa/cj6DQZEp/teABUKQZArjYZUu3rLGFeTLivutAsOjd6s+j9bBL4PSMKDiiNfOG+jM18jiv61bwos2rAXcaH4b5lYllEnCXWOawGjriO9Y=
From: Chris Clayton <chris2553@googlemail.com>
Reply-To: chris2553@googlemail.com
To: Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: 2.6.25-rc2 regression in rt61pci wireless driver
Date: Tue, 19 Feb 2008 19:00:09 +0000
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
References: <c6b1100b0802160406l24fed9dcje1dbfc8907fd7a16@mail.gmail.com> <200802182251.35630.chris2553@googlemail.com> <200802191026.57640.IvDoorn@gmail.com>
In-Reply-To: <200802191026.57640.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_5cyuHID59JOZ9Tz"
Message-Id: <200802191900.09543.chris2553@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_5cyuHID59JOZ9Tz
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

On Tuesday 19 February 2008, Ivo van Doorn wrote:
> Hi,
> 
> > > I have a series of tests I would like to request from you,
> > > you mentioned you already enabled debugfs, and that is just what we need. ;)
> > > Please use attached script to create dumps of the hardware register contents.
> > > 
> > > There are specific moments that should be dumped:
> > > - kernel 2.6.24 (last known working version for you).
> > > - kernel 2.6.25-rc2 (after ifup, before TX dies)
> > > - kernel 2.6.25-rc2 (after ifup, after TX dies)
> > >  
> > 
> > These diagnostics are attached, with obvious filenames.
> 
> Thanks. I think I found something, please test below patch:
> 

I've tried the patch but, unfortunately, my wireless LAN still dies after a few pings.

The frame dump diagnostics you asked for are attached. This is a fresh dump taken
tonight running the driver with your patch applied.


Chris
-- 
Beauty is in the eye of the beerholder.

--Boundary-00=_5cyuHID59JOZ9Tz
Content-Type: text/plain;
  charset="iso-8859-15";
  name="rt61txrxdump.pcap.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="rt61txrxdump.pcap.txt"

No.     Time        Source                Destination           Protocol Info
      1 0.000000    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2436, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 1 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
      2 0.102312    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2437, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 2 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
      3 0.204897    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2438, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 3 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
      4 0.306948    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2439, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 4 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
      5 0.409681    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2440, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 5 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
      6 0.511815    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2441, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 6 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
      7 0.614034    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2442, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 7 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
      8 0.716870    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2443, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 8 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
      9 0.818914    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2444, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 9 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     10 0.921176    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2445, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 10 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     11 1.023945    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2446, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 11 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     12 1.126258    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2447, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 12 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     13 1.228361    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2448, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 13 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     14 1.276110    Belkin_de:04:f4       Broadcast             ARP      Who has 192.168.1.1?  Tell 192.168.1.30

Frame 14 (160 bytes on wire, 160 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 TX descriptor
IEEE 802.11 Data, Flags: .......T
Logical-Link Control
Address Resolution Protocol (request)

No.     Time        Source                Destination           Protocol Info
     15 1.277201    Belkin_de:04:f4       Broadcast             ARP      Who has 192.168.1.1?  Tell 192.168.1.30

Frame 15 (160 bytes on wire, 160 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 TX descriptor
IEEE 802.11 Data, Flags: .......T
Logical-Link Control
Address Resolution Protocol (request)

No.     Time        Source                Destination           Protocol Info
     16 1.278808    Draytek_07:3e:10      Belkin_de:04:f4       ARP      192.168.1.1 is at 00:50:7f:07:3e:10

Frame 16 (160 bytes on wire, 160 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Data, Flags: ......F.
Logical-Link Control
Address Resolution Protocol (reply)

No.     Time        Source                Destination           Protocol Info
     17 1.278850    192.168.1.30          192.168.1.1           ICMP     Echo (ping) request

Frame 17 (216 bytes on wire, 216 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 TX descriptor
IEEE 802.11 Data, Flags: .......T
Logical-Link Control
Internet Protocol, Src: 192.168.1.30 (192.168.1.30), Dst: 192.168.1.1 (192.168.1.1)
Internet Control Message Protocol

No.     Time        Source                Destination           Protocol Info
     18 1.280717    192.168.1.30          192.168.1.1           ICMP     Echo (ping) request

Frame 18 (216 bytes on wire, 216 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 TX descriptor
IEEE 802.11 Data, Flags: .......T
Logical-Link Control
Internet Protocol, Src: 192.168.1.30 (192.168.1.30), Dst: 192.168.1.1 (192.168.1.1)
Internet Control Message Protocol

No.     Time        Source                Destination           Protocol Info
     19 1.283123    192.168.1.1           192.168.1.30          ICMP     Echo (ping) reply

Frame 19 (216 bytes on wire, 216 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Data, Flags: ......F.
Logical-Link Control
Internet Protocol, Src: 192.168.1.1 (192.168.1.1), Dst: 192.168.1.30 (192.168.1.30)
Internet Control Message Protocol

No.     Time        Source                Destination           Protocol Info
     20 1.330840    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2451, FN=0, Flags=..m....., BI=100, SSID=Broadcast

Frame 20 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ..m.....
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     21 1.331609    Belkin_de:04:f4       Broadcast             ARP      Who has 192.168.1.1?  Tell 192.168.1.30

Frame 21 (160 bytes on wire, 160 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Data, Flags: ......F.
Logical-Link Control
Address Resolution Protocol (request)

No.     Time        Source                Destination           Protocol Info
     22 1.433570    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2453, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 22 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     23 1.535540    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2454, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 23 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     24 1.637933    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2455, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 24 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     25 1.740750    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2456, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 25 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     26 1.842851    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2457, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 26 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     27 1.945583    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2458, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 27 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     28 2.047791    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2459, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 28 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     29 2.150300    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2460, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 29 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     30 2.252507    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2461, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 30 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     31 2.277481    192.168.1.30          192.168.1.1           ICMP     Echo (ping) request

Frame 31 (216 bytes on wire, 216 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 TX descriptor
IEEE 802.11 Data, Flags: .......T
Logical-Link Control
Internet Protocol, Src: 192.168.1.30 (192.168.1.30), Dst: 192.168.1.1 (192.168.1.1)
Internet Control Message Protocol

No.     Time        Source                Destination           Protocol Info
     32 2.279021    192.168.1.30          192.168.1.1           ICMP     Echo (ping) request

Frame 32 (216 bytes on wire, 216 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 TX descriptor
IEEE 802.11 Data, Flags: .......T
Logical-Link Control
Internet Protocol, Src: 192.168.1.30 (192.168.1.30), Dst: 192.168.1.1 (192.168.1.1)
Internet Control Message Protocol

No.     Time        Source                Destination           Protocol Info
     33 2.281142    192.168.1.1           192.168.1.30          ICMP     Echo (ping) reply

Frame 33 (216 bytes on wire, 216 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Data, Flags: ......F.
Logical-Link Control
Internet Protocol, Src: 192.168.1.1 (192.168.1.1), Dst: 192.168.1.30 (192.168.1.30)
Internet Control Message Protocol

No.     Time        Source                Destination           Protocol Info
     34 2.354734    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2463, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 34 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     35 2.457418    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2464, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 35 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     36 2.559690    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2465, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 36 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     37 2.661874    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2466, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 37 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     38 2.764387    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2467, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 38 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     39 2.866883    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2468, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 39 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     40 2.969206    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2469, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 40 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     41 3.071917    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2470, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 41 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     42 3.174313    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2471, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 42 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     43 3.276233    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2472, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 43 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     44 3.280300    192.168.1.30          192.168.1.1           ICMP     Echo (ping) request

Frame 44 (216 bytes on wire, 216 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 TX descriptor
IEEE 802.11 Data, Flags: .......T
Logical-Link Control
Internet Protocol, Src: 192.168.1.30 (192.168.1.30), Dst: 192.168.1.1 (192.168.1.1)
Internet Control Message Protocol

No.     Time        Source                Destination           Protocol Info
     45 3.281843    192.168.1.30          192.168.1.1           ICMP     Echo (ping) request

Frame 45 (216 bytes on wire, 216 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 TX descriptor
IEEE 802.11 Data, Flags: .......T
Logical-Link Control
Internet Protocol, Src: 192.168.1.30 (192.168.1.30), Dst: 192.168.1.1 (192.168.1.1)
Internet Control Message Protocol

No.     Time        Source                Destination           Protocol Info
     46 3.284286    192.168.1.1           192.168.1.30          ICMP     Echo (ping) reply

Frame 46 (216 bytes on wire, 216 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Data, Flags: ......F.
Logical-Link Control
Internet Protocol, Src: 192.168.1.1 (192.168.1.1), Dst: 192.168.1.30 (192.168.1.30)
Internet Control Message Protocol

No.     Time        Source                Destination           Protocol Info
     47 3.378782    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2474, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 47 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     48 3.481219    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2475, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 48 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     49 3.583446    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2476, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 49 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     50 3.686040    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2477, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 50 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     51 3.788205    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2478, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 51 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     52 3.890619    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2479, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 52 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     53 3.993194    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2480, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 53 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     54 4.095716    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2481, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 54 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     55 4.197944    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2482, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 55 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     56 4.281477    192.168.1.30          192.168.1.1           ICMP     Echo (ping) request

Frame 56 (216 bytes on wire, 216 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 TX descriptor
IEEE 802.11 Data, Flags: .......T
Logical-Link Control
Internet Protocol, Src: 192.168.1.30 (192.168.1.30), Dst: 192.168.1.1 (192.168.1.1)
Internet Control Message Protocol

No.     Time        Source                Destination           Protocol Info
     57 4.283019    192.168.1.30          192.168.1.1           ICMP     Echo (ping) request

Frame 57 (216 bytes on wire, 216 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 TX descriptor
IEEE 802.11 Data, Flags: .......T
Logical-Link Control
Internet Protocol, Src: 192.168.1.30 (192.168.1.30), Dst: 192.168.1.1 (192.168.1.1)
Internet Control Message Protocol

No.     Time        Source                Destination           Protocol Info
     58 4.285684    192.168.1.1           192.168.1.30          ICMP     Echo (ping) reply

Frame 58 (216 bytes on wire, 216 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Data, Flags: ......F.
Logical-Link Control
Internet Protocol, Src: 192.168.1.1 (192.168.1.1), Dst: 192.168.1.30 (192.168.1.30)
Internet Control Message Protocol

No.     Time        Source                Destination           Protocol Info
     59 4.300552    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2484, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 59 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     60 4.402581    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2485, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 60 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     61 4.505104    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2486, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 61 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     62 4.607412    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2487, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 62 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     63 4.709925    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2488, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 63 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     64 4.812147    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2489, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 64 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     65 4.914899    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2490, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 65 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     66 5.017277    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2491, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 66 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     67 5.119703    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2492, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 67 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     68 5.222224    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2493, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 68 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     69 5.285478    192.168.1.30          192.168.1.1           ICMP     Echo (ping) request

Frame 69 (216 bytes on wire, 216 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 TX descriptor
IEEE 802.11 Data, Flags: .......T
Logical-Link Control
Internet Protocol, Src: 192.168.1.30 (192.168.1.30), Dst: 192.168.1.1 (192.168.1.1)
Internet Control Message Protocol

No.     Time        Source                Destination           Protocol Info
     70 5.287019    192.168.1.30          192.168.1.1           ICMP     Echo (ping) request

Frame 70 (216 bytes on wire, 216 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 TX descriptor
IEEE 802.11 Data, Flags: .......T
Logical-Link Control
Internet Protocol, Src: 192.168.1.30 (192.168.1.30), Dst: 192.168.1.1 (192.168.1.1)
Internet Control Message Protocol

No.     Time        Source                Destination           Protocol Info
     71 5.289438    192.168.1.1           192.168.1.30          ICMP     Echo (ping) reply

Frame 71 (216 bytes on wire, 216 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Data, Flags: ......F.
Logical-Link Control
Internet Protocol, Src: 192.168.1.1 (192.168.1.1), Dst: 192.168.1.30 (192.168.1.30)
Internet Control Message Protocol

No.     Time        Source                Destination           Protocol Info
     72 5.324476    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2495, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 72 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     73 5.426913    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2496, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 73 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     74 5.528947    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2497, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 74 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     75 5.631410    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2498, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 75 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     76 5.733837    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2499, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 76 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     77 5.836091    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2500, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 77 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     78 5.938871    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2501, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 78 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     79 6.040994    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2502, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 79 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     80 6.143534    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2503, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 80 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     81 6.246158    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2504, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 81 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     82 6.289473    192.168.1.30          192.168.1.1           ICMP     Echo (ping) request

Frame 82 (216 bytes on wire, 216 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 TX descriptor
IEEE 802.11 Data, Flags: .......T
Logical-Link Control
Internet Protocol, Src: 192.168.1.30 (192.168.1.30), Dst: 192.168.1.1 (192.168.1.1)
Internet Control Message Protocol

No.     Time        Source                Destination           Protocol Info
     83 6.291013    192.168.1.30          192.168.1.1           ICMP     Echo (ping) request

Frame 83 (216 bytes on wire, 216 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 TX descriptor
IEEE 802.11 Data, Flags: .......T
Logical-Link Control
Internet Protocol, Src: 192.168.1.30 (192.168.1.30), Dst: 192.168.1.1 (192.168.1.1)
Internet Control Message Protocol

No.     Time        Source                Destination           Protocol Info
     84 6.293538    192.168.1.1           192.168.1.30          ICMP     Echo (ping) reply

Frame 84 (216 bytes on wire, 216 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Data, Flags: ......F.
Logical-Link Control
Internet Protocol, Src: 192.168.1.1 (192.168.1.1), Dst: 192.168.1.30 (192.168.1.30)
Internet Control Message Protocol

No.     Time        Source                Destination           Protocol Info
     85 6.348367    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2506, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 85 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     86 6.450462    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2507, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 86 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     87 6.553112    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2508, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 87 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     88 6.655241    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2509, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 88 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     89 6.757723    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2510, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 89 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     90 6.860031    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2511, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 90 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     91 6.962533    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2512, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 91 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     92 7.064873    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2513, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 92 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     93 7.167449    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2514, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 93 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     94 7.269707    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2515, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 94 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     95 7.293479    192.168.1.30          192.168.1.1           ICMP     Echo (ping) request

Frame 95 (216 bytes on wire, 216 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 TX descriptor
IEEE 802.11 Data, Flags: .......T
Logical-Link Control
Internet Protocol, Src: 192.168.1.30 (192.168.1.30), Dst: 192.168.1.1 (192.168.1.1)
Internet Control Message Protocol

No.     Time        Source                Destination           Protocol Info
     96 7.294485    192.168.1.30          192.168.1.1           ICMP     Echo (ping) request

Frame 96 (216 bytes on wire, 216 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 TX descriptor
IEEE 802.11 Data, Flags: .......T
Logical-Link Control
Internet Protocol, Src: 192.168.1.30 (192.168.1.30), Dst: 192.168.1.1 (192.168.1.1)
Internet Control Message Protocol

No.     Time        Source                Destination           Protocol Info
     97 7.296497    192.168.1.1           192.168.1.30          ICMP     Echo (ping) reply

Frame 97 (216 bytes on wire, 216 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Data, Flags: ......F.
Logical-Link Control
Internet Protocol, Src: 192.168.1.1 (192.168.1.1), Dst: 192.168.1.30 (192.168.1.30)
Internet Control Message Protocol

No.     Time        Source                Destination           Protocol Info
     98 7.372092    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2517, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 98 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
     99 7.474373    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2518, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 99 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    100 7.576792    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2519, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 100 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    101 7.679628    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2520, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 101 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    102 7.781554    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2521, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 102 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    103 7.884125    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2522, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 103 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    104 7.986368    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2523, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 104 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    105 8.088914    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2524, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 105 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    106 8.191542    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2525, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 106 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    107 8.293882    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2526, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 107 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    108 8.300612    192.168.1.30          192.168.1.1           ICMP     Echo (ping) request

Frame 108 (216 bytes on wire, 216 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 TX descriptor
IEEE 802.11 Data, Flags: .......T
Logical-Link Control
Internet Protocol, Src: 192.168.1.30 (192.168.1.30), Dst: 192.168.1.1 (192.168.1.1)
Internet Control Message Protocol

No.     Time        Source                Destination           Protocol Info
    109 8.301277    192.168.1.30          192.168.1.1           ICMP     Echo (ping) request

Frame 109 (216 bytes on wire, 216 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 TX descriptor
IEEE 802.11 Data, Flags: .......T
Logical-Link Control
Internet Protocol, Src: 192.168.1.30 (192.168.1.30), Dst: 192.168.1.1 (192.168.1.1)
Internet Control Message Protocol

No.     Time        Source                Destination           Protocol Info
    110 8.302821    192.168.1.1           192.168.1.30          ICMP     Echo (ping) reply

Frame 110 (216 bytes on wire, 216 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Data, Flags: ......F.
Logical-Link Control
Internet Protocol, Src: 192.168.1.1 (192.168.1.1), Dst: 192.168.1.30 (192.168.1.30)
Internet Control Message Protocol

No.     Time        Source                Destination           Protocol Info
    111 8.396422    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2528, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 111 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    112 8.498756    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2529, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 112 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    113 8.600734    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2530, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 113 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    114 8.703126    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2531, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 114 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    115 8.805819    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2532, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 115 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    116 8.907914    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2533, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 116 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    117 9.010652    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2534, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 117 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    118 9.112786    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2535, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 118 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    119 9.215564    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2536, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 119 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    120 9.301477    192.168.1.30          192.168.1.1           ICMP     Echo (ping) request

Frame 120 (216 bytes on wire, 216 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 TX descriptor
IEEE 802.11 Data, Flags: .......T
Logical-Link Control
Internet Protocol, Src: 192.168.1.30 (192.168.1.30), Dst: 192.168.1.1 (192.168.1.1)
Internet Control Message Protocol

No.     Time        Source                Destination           Protocol Info
    121 9.317732    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2537, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 121 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    122 9.345021    192.168.1.30          192.168.1.1           ICMP     Echo (ping) request

Frame 122 (216 bytes on wire, 216 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 TX descriptor
IEEE 802.11 Data, Flags: .......T
Logical-Link Control
Internet Protocol, Src: 192.168.1.30 (192.168.1.30), Dst: 192.168.1.1 (192.168.1.1)
Internet Control Message Protocol

No.     Time        Source                Destination           Protocol Info
    123 9.419993    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2538, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 123 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    124 9.522624    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2539, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 124 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    125 9.624708    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2540, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 125 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    126 9.727489    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2541, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 126 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    127 9.829797    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2542, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 127 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    128 9.931856    Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2543, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 128 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    129 10.034690   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2544, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 129 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    130 10.136679   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2545, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 130 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    131 10.239251   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2546, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 131 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    132 10.305424   192.168.1.30          192.168.1.1           ICMP     Echo (ping) request

Frame 132 (216 bytes on wire, 216 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 TX descriptor
IEEE 802.11 Data, Flags: .......T
Logical-Link Control
Internet Protocol, Src: 192.168.1.30 (192.168.1.30), Dst: 192.168.1.1 (192.168.1.1)
Internet Control Message Protocol

No.     Time        Source                Destination           Protocol Info
    133 10.341433   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2547, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 133 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    134 10.342477   192.168.1.30          192.168.1.1           ICMP     Echo (ping) request

Frame 134 (216 bytes on wire, 216 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 TX descriptor
IEEE 802.11 Data, Flags: .......T
Logical-Link Control
Internet Protocol, Src: 192.168.1.30 (192.168.1.30), Dst: 192.168.1.1 (192.168.1.1)
Internet Control Message Protocol

No.     Time        Source                Destination           Protocol Info
    135 10.444089   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2548, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 135 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    136 10.546307   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2549, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 136 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    137 10.649093   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2550, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 137 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    138 10.751034   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2551, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 138 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    139 10.853870   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2552, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 139 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    140 10.955771   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2553, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 140 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    141 11.058189   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2554, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 141 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    142 11.160586   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2555, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 142 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    143 11.263072   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2556, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 143 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    144 11.309426   192.168.1.30          192.168.1.1           ICMP     Echo (ping) request

Frame 144 (216 bytes on wire, 216 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 TX descriptor
IEEE 802.11 Data, Flags: .......T
Logical-Link Control
Internet Protocol, Src: 192.168.1.30 (192.168.1.30), Dst: 192.168.1.1 (192.168.1.1)
Internet Control Message Protocol

No.     Time        Source                Destination           Protocol Info
    145 11.346241   192.168.1.30          192.168.1.1           ICMP     Echo (ping) request

Frame 145 (216 bytes on wire, 216 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 TX descriptor
IEEE 802.11 Data, Flags: .......T
Logical-Link Control
Internet Protocol, Src: 192.168.1.30 (192.168.1.30), Dst: 192.168.1.1 (192.168.1.1)
Internet Control Message Protocol

No.     Time        Source                Destination           Protocol Info
    146 11.365667   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2557, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 146 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    147 11.468257   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2558, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 147 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    148 11.570481   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2559, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 148 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    149 11.673014   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2560, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 149 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    150 11.775187   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2561, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 150 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    151 11.877826   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2562, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 151 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    152 11.979741   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2563, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 152 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    153 12.082404   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2564, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 153 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    154 12.184526   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2565, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 154 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    155 12.287421   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2566, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 155 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    156 12.313454   192.168.1.30          192.168.1.1           ICMP     Echo (ping) request

Frame 156 (216 bytes on wire, 216 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 TX descriptor
IEEE 802.11 Data, Flags: .......T
Logical-Link Control
Internet Protocol, Src: 192.168.1.30 (192.168.1.30), Dst: 192.168.1.1 (192.168.1.1)
Internet Control Message Protocol

No.     Time        Source                Destination           Protocol Info
    157 12.342855   192.168.1.30          192.168.1.1           ICMP     Echo (ping) request

Frame 157 (216 bytes on wire, 216 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 TX descriptor
IEEE 802.11 Data, Flags: .......T
Logical-Link Control
Internet Protocol, Src: 192.168.1.30 (192.168.1.30), Dst: 192.168.1.1 (192.168.1.1)
Internet Control Message Protocol

No.     Time        Source                Destination           Protocol Info
    158 12.389602   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2567, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 158 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    159 12.492118   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2568, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 159 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    160 12.594228   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2569, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 160 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    161 12.696822   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2570, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 161 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    162 12.799311   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2571, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 162 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    163 12.901285   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2572, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 163 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    164 13.003682   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2573, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 164 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    165 13.106101   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2574, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 165 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    166 13.208469   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2575, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 166 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    167 13.311161   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2576, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 167 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    168 13.316850   192.168.1.30          192.168.1.1           ICMP     Echo (ping) request

Frame 168 (216 bytes on wire, 216 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 TX descriptor
IEEE 802.11 Data, Flags: .......T
Logical-Link Control
Internet Protocol, Src: 192.168.1.30 (192.168.1.30), Dst: 192.168.1.1 (192.168.1.1)
Internet Control Message Protocol

No.     Time        Source                Destination           Protocol Info
    169 13.344063   192.168.1.30          192.168.1.1           ICMP     Echo (ping) request

Frame 169 (216 bytes on wire, 216 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 TX descriptor
IEEE 802.11 Data, Flags: .......T
Logical-Link Control
Internet Protocol, Src: 192.168.1.30 (192.168.1.30), Dst: 192.168.1.1 (192.168.1.1)
Internet Control Message Protocol

No.     Time        Source                Destination           Protocol Info
    170 13.413403   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2577, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 170 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    171 13.516042   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2578, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 171 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    172 13.618046   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2579, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 172 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    173 13.720862   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2580, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 173 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    174 13.822835   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2581, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 174 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    175 13.925508   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2582, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 175 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    176 14.028036   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2583, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 176 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    177 14.130165   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2584, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 177 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    178 14.232757   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2585, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 178 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    179 14.317425   192.168.1.30          192.168.1.1           ICMP     Echo (ping) request

Frame 179 (216 bytes on wire, 216 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 TX descriptor
IEEE 802.11 Data, Flags: .......T
Logical-Link Control
Internet Protocol, Src: 192.168.1.30 (192.168.1.30), Dst: 192.168.1.1 (192.168.1.1)
Internet Control Message Protocol

No.     Time        Source                Destination           Protocol Info
    180 14.334852   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2586, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 180 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    181 14.335775   192.168.1.30          192.168.1.1           ICMP     Echo (ping) request

Frame 181 (216 bytes on wire, 216 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 TX descriptor
IEEE 802.11 Data, Flags: .......T
Logical-Link Control
Internet Protocol, Src: 192.168.1.30 (192.168.1.30), Dst: 192.168.1.1 (192.168.1.1)
Internet Control Message Protocol

No.     Time        Source                Destination           Protocol Info
    182 14.437398   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2587, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 182 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    183 14.539626   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2588, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 183 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    184 14.642103   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2589, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 184 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    185 14.744381   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2590, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 185 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    186 14.846776   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2591, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 186 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    187 14.949233   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2592, FN=0, Flags=..m....., BI=100, SSID=Broadcast

Frame 187 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ..m.....
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    188 14.949691   Draytek_07:3e:10      Broadcast             ARP      Who has 192.168.1.10?  Tell 192.168.1.1

Frame 188 (160 bytes on wire, 160 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Data, Flags: ......F.
Logical-Link Control
Address Resolution Protocol (request)

No.     Time        Source                Destination           Protocol Info
    189 15.051741   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2594, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 189 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    190 15.154475   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2595, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 190 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    191 15.256605   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2596, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 191 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    192 15.321423   192.168.1.30          192.168.1.1           ICMP     Echo (ping) request

Frame 192 (216 bytes on wire, 216 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 TX descriptor
IEEE 802.11 Data, Flags: .......T
Logical-Link Control
Internet Protocol, Src: 192.168.1.30 (192.168.1.30), Dst: 192.168.1.1 (192.168.1.1)
Internet Control Message Protocol

No.     Time        Source                Destination           Protocol Info
    193 15.358747   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2597, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 193 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    194 15.362532   192.168.1.30          192.168.1.1           ICMP     Echo (ping) request

Frame 194 (216 bytes on wire, 216 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 TX descriptor
IEEE 802.11 Data, Flags: .......T
Logical-Link Control
Internet Protocol, Src: 192.168.1.30 (192.168.1.30), Dst: 192.168.1.1 (192.168.1.1)
Internet Control Message Protocol

No.     Time        Source                Destination           Protocol Info
    195 15.461487   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2598, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 195 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    196 15.563992   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2599, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 196 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    197 15.666088   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2600, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 197 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    198 15.768516   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2601, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 198 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    199 15.870724   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2602, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 199 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    200 15.973370   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2603, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 200 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    201 16.075509   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2604, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 201 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    202 16.178128   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2605, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 202 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    203 16.280299   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2606, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 203 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    204 16.325421   192.168.1.30          192.168.1.1           ICMP     Echo (ping) request

Frame 204 (216 bytes on wire, 216 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 TX descriptor
IEEE 802.11 Data, Flags: .......T
Logical-Link Control
Internet Protocol, Src: 192.168.1.30 (192.168.1.30), Dst: 192.168.1.1 (192.168.1.1)
Internet Control Message Protocol

No.     Time        Source                Destination           Protocol Info
    205 16.357398   192.168.1.30          192.168.1.1           ICMP     Echo (ping) request

Frame 205 (216 bytes on wire, 216 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 TX descriptor
IEEE 802.11 Data, Flags: .......T
Logical-Link Control
Internet Protocol, Src: 192.168.1.30 (192.168.1.30), Dst: 192.168.1.1 (192.168.1.1)
Internet Control Message Protocol

No.     Time        Source                Destination           Protocol Info
    206 16.382693   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2607, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 206 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    207 16.485087   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2608, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 207 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    208 16.587483   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2609, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 208 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    209 16.689953   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2610, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 209 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    210 16.792527   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2611, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 210 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    211 16.894744   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2612, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 211 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    212 16.997324   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2613, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 212 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    213 17.099453   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2614, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 213 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    214 17.202064   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2615, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 214 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    215 17.304671   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2616, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 215 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    216 17.329433   192.168.1.30          192.168.1.1           ICMP     Echo (ping) request

Frame 216 (216 bytes on wire, 216 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 TX descriptor
IEEE 802.11 Data, Flags: .......T
Logical-Link Control
Internet Protocol, Src: 192.168.1.30 (192.168.1.30), Dst: 192.168.1.1 (192.168.1.1)
Internet Control Message Protocol

No.     Time        Source                Destination           Protocol Info
    217 17.344586   192.168.1.30          192.168.1.1           ICMP     Echo (ping) request

Frame 217 (216 bytes on wire, 216 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 TX descriptor
IEEE 802.11 Data, Flags: .......T
Logical-Link Control
Internet Protocol, Src: 192.168.1.30 (192.168.1.30), Dst: 192.168.1.1 (192.168.1.1)
Internet Control Message Protocol

No.     Time        Source                Destination           Protocol Info
    218 17.406998   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2617, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 218 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    219 17.509113   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2618, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 219 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    220 17.611721   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2619, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 220 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    221 17.714018   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2620, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 221 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    222 17.816212   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2621, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 222 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    223 17.918608   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2622, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 223 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    224 18.021001   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2623, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 224 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    225 18.123586   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2624, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 225 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    226 18.225801   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2625, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 226 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    227 18.328660   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2626, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 227 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    228 18.333208   192.168.1.30          192.168.1.1           ICMP     Echo (ping) request

Frame 228 (216 bytes on wire, 216 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 TX descriptor
IEEE 802.11 Data, Flags: .......T
Logical-Link Control
Internet Protocol, Src: 192.168.1.30 (192.168.1.30), Dst: 192.168.1.1 (192.168.1.1)
Internet Control Message Protocol

No.     Time        Source                Destination           Protocol Info
    229 18.355365   192.168.1.30          192.168.1.1           ICMP     Echo (ping) request

Frame 229 (216 bytes on wire, 216 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 TX descriptor
IEEE 802.11 Data, Flags: .......T
Logical-Link Control
Internet Protocol, Src: 192.168.1.30 (192.168.1.30), Dst: 192.168.1.1 (192.168.1.1)
Internet Control Message Protocol

No.     Time        Source                Destination           Protocol Info
    230 18.430689   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2627, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 230 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    231 18.533344   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2628, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 231 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    232 18.635366   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2629, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 232 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    233 18.738055   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2630, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 233 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    234 18.840629   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2631, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 234 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    235 18.942545   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2632, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 235 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    236 19.045541   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2633, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 236 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    237 19.147549   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2634, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 237 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    238 19.250016   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2635, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 238 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    239 19.333459   192.168.1.30          192.168.1.1           ICMP     Echo (ping) request

Frame 239 (216 bytes on wire, 216 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 TX descriptor
IEEE 802.11 Data, Flags: .......T
Logical-Link Control
Internet Protocol, Src: 192.168.1.30 (192.168.1.30), Dst: 192.168.1.1 (192.168.1.1)
Internet Control Message Protocol

No.     Time        Source                Destination           Protocol Info
    240 19.352173   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2636, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 240 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    241 19.370077   192.168.1.30          192.168.1.1           ICMP     Echo (ping) request

Frame 241 (216 bytes on wire, 216 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 TX descriptor
IEEE 802.11 Data, Flags: .......T
Logical-Link Control
Internet Protocol, Src: 192.168.1.30 (192.168.1.30), Dst: 192.168.1.1 (192.168.1.1)
Internet Control Message Protocol

No.     Time        Source                Destination           Protocol Info
    242 19.454732   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2637, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 242 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    243 19.557215   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2638, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 243 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    244 19.659421   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2639, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 244 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    245 19.762079   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2640, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 245 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    246 19.864437   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2641, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 246 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    247 19.966765   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2642, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 247 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    248 20.068879   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2643, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 248 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    249 20.171610   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2644, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 249 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    250 20.273800   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2645, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 250 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    251 20.341356   192.168.1.30          192.168.1.1           ICMP     Echo (ping) request

Frame 251 (216 bytes on wire, 216 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 TX descriptor
IEEE 802.11 Data, Flags: .......T
Logical-Link Control
Internet Protocol, Src: 192.168.1.30 (192.168.1.30), Dst: 192.168.1.1 (192.168.1.1)
Internet Control Message Protocol

No.     Time        Source                Destination           Protocol Info
    252 20.366375   192.168.1.30          192.168.1.1           ICMP     Echo (ping) request

Frame 252 (216 bytes on wire, 216 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 TX descriptor
IEEE 802.11 Data, Flags: .......T
Logical-Link Control
Internet Protocol, Src: 192.168.1.30 (192.168.1.30), Dst: 192.168.1.1 (192.168.1.1)
Internet Control Message Protocol

No.     Time        Source                Destination           Protocol Info
    253 20.376063   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2646, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 253 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    254 20.478540   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2647, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 254 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    255 20.581236   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2648, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 255 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    256 20.707554   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2649, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 256 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    257 20.785683   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2650, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 257 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

No.     Time        Source                Destination           Protocol Info
    258 20.888031   Z-Com_77:73:1a        Broadcast             IEEE 802.11 Beacon frame, SN=2651, FN=0, Flags=........, BI=100, SSID=Broadcast

Frame 258 (153 bytes on wire, 153 bytes captured)
DLT: 147
rt2x00 tx/rx dump
rt61 RX descriptor
IEEE 802.11 Beacon frame, Flags: ........
IEEE 802.11 wireless LAN management frame

--Boundary-00=_5cyuHID59JOZ9Tz--
