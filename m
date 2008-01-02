Return-Path: <linux-kernel-owner+w=401wt.eu-S1756291AbYABTQj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291AbYABTQj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2008 14:16:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752687AbYABTQb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jan 2008 14:16:31 -0500
Received: from smtp116.sbc.mail.sp1.yahoo.com ([69.147.64.89]:25842 "HELO
	smtp116.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751934AbYABTQb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2008 14:16:31 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=WZZfTW9t5QnE3aEzYGjX2DTtu1+vAV1y2huIAw/quCFbJ9m/t19ltU68k1zUJJm2TTUnNaRm6y/COTgLDyhtEaYGxHelEsnvV91gWVVB180u+HX8w55uRPzzufA5baao7EG05awAZrP97OGZuOYPaOLZdt3Zd9gNkXK3tNu9U30=  ;
X-YMail-OSG: NHf6TpUVM1nbw0BIKWtp4ptzKW8D6mshiVu6x1wBt8_mP6svip0mQXYBEVlTZHdfCNV5KrtOxg--
From: David Brownell <david-b@pacbell.net>
To: linux-usb-devel@lists.sourceforge.net
Subject: Re: [linux-usb-devel] [PATCH] : Allow embedded developers USB options normally reserved for OTG
Date: Wed, 2 Jan 2008 11:16:28 -0800
User-Agent: KMail/1.9.6
Cc: "Mike Frysinger" <vapier.adi@gmail.com>, gregkh@suse.de,
       Robin Getz <rgetz@blackfin.uclinux.org>, linux-kernel@vger.kernel.org
References: <200801020948.51310.rgetz@blackfin.uclinux.org> <200801021047.16036.david-b@pacbell.net> <8bd0f97a0801021058g15d32de7nd29102ec552ba5fa@mail.gmail.com>
In-Reply-To: <8bd0f97a0801021058g15d32de7nd29102ec552ba5fa@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Message-Id: <200801021116.29067.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 02 January 2008, Mike Frysinger wrote:
> > >
> > > Allow embedded developers to turn support for USB Hubs off even if they have a
> > > full root hub. This saves the overhead (RAM and Flash size).
> >
> > ISTR that it won't save very much code though ... the Linux USB
> > stack structures all its enumeration logic around hubs.
> 
> perhaps the code size is arguable as to whether it really matters.
> the reason we want it is that we have a USB host controller that will
> not work with USB hubs, so we want to make sure the system does not
> attempt such things.  (yes, such a USB host controller is retarded,
> but the decision was out of our hands.)

Well, it won't work with *external* hubs.  Root hubs are a different
story.  :)

I think that's one of a class of decisions sometimes made by folk
who need to conserve silicon real estate.  Supporting external hubs
has always been optional for OTG systems.

- Dave


