Return-Path: <linux-kernel-owner+w=401wt.eu-S1758428AbZJFXCA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758428AbZJFXCA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Oct 2009 19:02:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756579AbZJFXB7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Oct 2009 19:01:59 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57754 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757554AbZJFXB7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Oct 2009 19:01:59 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [linux-pm] Massive ext4 filesystem corruption after a failed s2disk/ram cycle
Date: Wed, 7 Oct 2009 01:02:47 +0200
User-Agent: KMail/1.12.1 (Linux/2.6.32-rc3-rjw; KDE/4.3.1; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       "linux-kernel" <linux-kernel@vger.kernel.org>
References: <1254863215.11577.23.camel@maxim-laptop> <200910062358.32417.rjw@sisk.pl> <20091006225329.GA27646@khazad-dum.debian.net>
In-Reply-To: <20091006225329.GA27646@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200910070102.47293.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 October 2009, Henrique de Moraes Holschuh wrote:
> On Tue, 06 Oct 2009, Rafael J. Wysocki wrote:
> > > You do sync file-systems before entering the hibernation, don't you?
> > 
> > Yes, a sync is there, but it is not effective on some filesystems.
> 
> Which ones?

XFS for one example.
