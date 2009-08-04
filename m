Return-Path: <linux-kernel-owner+w=401wt.eu-S932880AbZHDPcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932880AbZHDPcx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Aug 2009 11:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755639AbZHDPcw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Aug 2009 11:32:52 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45024 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755630AbZHDPcu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Aug 2009 11:32:50 -0400
From: Juergen Beisert <jbe@pengutronix.de>
Organization: Pengutronix - Linux Solutions for Science and Industry
To: linux-kernel@vger.kernel.org
Date: Tue, 4 Aug 2009 17:32:40 +0200
User-Agent: KMail/1.9.9
References: <cb0375e10908031414g471bacf5lab685958b60bfdfa@mail.gmail.com> <cb0375e10908031501w610d1e27ya69d7c2011f93555@mail.gmail.com> <cb0375e10908031600v4db81c51hd98094ef9a0a5a16@mail.gmail.com>
In-Reply-To: <cb0375e10908031600v4db81c51hd98094ef9a0a5a16@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200908041732.40215.jbe@pengutronix.de>
X-SA-Exim-Connect-IP: 92.198.50.58
X-SA-Exim-Mail-From: jbe@pengutronix.de
Subject: Re: Is anyone maintaining (or even using) usbtmc?
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.ext.pengutronix.de)
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dienstag, 4. August 2009, Andrew Lutomirski wrote:
> On Mon, Aug 3, 2009 at 6:01 PM, Andrew Lutomirski<luto@mit.edu> wrote:
> > On Mon, Aug 3, 2009 at 5:49 PM, Andrew Lutomirski<luto@mit.edu> wrote:
> >> On Mon, Aug 3, 2009 at 5:20 PM, Greg KH<greg@kroah.com> wrote:
> >>> On Mon, Aug 03, 2009 at 05:14:56PM -0400, Andrew Lutomirski wrote:
> >>>> Hi all-
> >>>>
> >>>> I'm trying to use usbtmc on an Aglient N9310A (The only TMC device I
> >>>> have), and it sort of works, but it seems to be both extremely buggy
> >>>> and missing a good deal of rather important functionality.  Is there
> >>>> anyone maintaining it?
> >>>
> >>> Yes, me.
> >>>
> >>>> If the answer is yes, I can describe the bugs (logspam, spurious
> >>>> errors, delayed messages, inability to read status, etc.) in greater
> >>>> detail.
> >>>
> >>> Please do, but also please use the latest version, in 2.6.30.3, we
> >>> fixed some bad problems in it recently.
> >>
> >> I am.
> >>
> >> Almost anything I do triggers this:
> >>
> >> usbtmc 3-1:1.0: Unable to read data, error -110
>
> My N9310A is now totally wedged.  Anything I can think of doing (send
> queries, send *RST, or any of the CLEAR ioctls) fails and spews stuff
> like this:
>
> [360946.881771] usbtmc 3-1:1.0: Unable to send data, error -110
> [360946.890770] usbtmc 3-1:1.0: usb_bulk_msg returned -110
> [360965.303400] usb 3-1: usb_control_msg returned -110
> [360965.312404] usb 3-1: usb_control_msg returned -110
> [361052.364626] usbtmc 3-1:1.0: usb_bulk_msg returned -110
> [361055.114579] usbtmc 3-1:1.0: Unable to send data, error -110
> [361055.123574] usbtmc 3-1:1.0: usb_bulk_msg returned -110
>
> I'm going to leave it like this in case you want me to try something.

Could I help also with tests? I have a Tektronix TDS 1001B here with TMC 
capability.

Juergen

-- 
Pengutronix e.K.                              | Juergen Beisert             |
Linux Solutions for Science and Industry      | Phone: +49-8766-939 228     |
Vertretung Sued/Muenchen, Germany             | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686              | http://www.pengutronix.de/  |
