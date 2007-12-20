Return-Path: <linux-kernel-owner+w=401wt.eu-S936070AbXLTQJF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936070AbXLTQJF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 11:09:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933261AbXLTQIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 11:08:49 -0500
Received: from fg-out-1718.google.com ([72.14.220.155]:51677 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761728AbXLTQIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 11:08:47 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=g8Flt9EFX8lSSFojcRVY8rS72kje655Aa5tszMClO/H7FIWzkMlF19U8KG4vGLzE6ZioOiuxCzZsPGxtwhCOAKw+k/MW7StUGdjx99+qufYmljRwPwtswp7P3byymeBrKfs/Qqm35N0cYfQX2O+2r4fjfWGTJGQpeLnG/RdVTmo=
Message-ID: <83a51e120712200808m7fa63e9jc588124a6da5f740@mail.gmail.com>
Date: Thu, 20 Dec 2007 11:08:45 -0500
From: "James Nichols" <jamesnichols3@gmail.com>
To: "Eric Dumazet" <dada1@cosmosbay.com>
Subject: Re: After many hours all outbound connections get stuck in SYN_SENT
Cc: "Jan Engelhardt" <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org,
       "Linux Netdev List" <netdev@vger.kernel.org>
In-Reply-To: <47695CEF.4090908@cosmosbay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <83a51e120712141239u52d2dd68p1b6ee7ed08f2cecf@mail.gmail.com>
	 <Pine.LNX.4.64.0712181910580.4422@fbirervta.pbzchgretzou.qr>
	 <83a51e120712181021p4c4c2a13g8820271f1e00361b@mail.gmail.com>
	 <4768123A.7040603@cosmosbay.com>
	 <83a51e120712181144l65633b32r72cc369f9d012f47@mail.gmail.com>
	 <47682F8C.20205@cosmosbay.com>
	 <83a51e120712190853q33d9c7c1t4a46380665b7538b@mail.gmail.com>
	 <47694FCC.1020507@cosmosbay.com>
	 <83a51e120712190943m3bf0e2e4v2ea6b660142e9a5a@mail.gmail.com>
	 <47695CEF.4090908@cosmosbay.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I still dont understand.
>
> "tcpdump -p -n -s 1600 -c 10000" doesnt reveal User data at all.
>
> Without any exact data from you, I am afraid nobody can help.

Oh, I didn't see that you specified specific options.  I'll still have
to anonymize 2000+ IP addresses, but I think there is an open source
tool that will do this for you.



> >> 2) Are you sure you are not using connection tracking, and hit a limit on it ?
> >
> > I'm using ip_conntrack, but the limit I have for max entries is 65K.
> > The most I've seen in there are a couple thousand- that was one of the
> > first things I monitored very closely.
>
> Now please try without conn tracking module. I saw many failures in the past
> that were trigered by conntrack.
>
> Do you have some firewall rules, using some netfilter modules like hashlimit ?

I will have to look into this.
