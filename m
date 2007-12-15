Return-Path: <linux-kernel-owner+w=401wt.eu-S1760054AbXLOKZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760054AbXLOKZU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2007 05:25:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753780AbXLOKZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Dec 2007 05:25:08 -0500
Received: from main.gmane.org ([80.91.229.2]:52599 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755199AbXLOKZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2007 05:25:07 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Holger Hoffstaette" <holger@wizards.de>
Subject: Re: Reproducible data corruption with sendfile+vsftp - splice regression?
Date: Sat, 15 Dec 2007 11:24:20 +0100
Organization: The Fists of the White Lotus
Message-ID: <pan.2007.12.15.10.24.20.327500@wizards.de>
References: <pan.2007.11.29.23.42.52.661624@wizards.de> <474FC4D9.3020506@cosmosbay.com> <pan.2007.11.30.09.20.24.737500@wizards.de> <475055EE.9060105@hp.com> <pan.2007.12.02.16.00.03.568000@wizards.de> <pan.2007.12.02.20.49.42.675000@wizards.de> <20071205225429.GA10186@electric-eye.fr.zoreil.com> <pan.2007.12.06.09.28.08.913625@wizards.de> <20071206184426.GA32599@electric-eye.fr.zoreil.com> <pan.2007.12.13.02.19.40.200510@wizards.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: port-87-234-135-174.dynamic.qsc.de
User-Agent: Pan/0.13.91 (Before we let euphoria convince us we are free)
Cc: netdev@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Dec 2007 03:19:43 +0100, Holger Hoffstaette wrote:

> I have now gone back to enable TSO since vsftp with sendfile really seems
> to be the only app that causes this. I have simply set it to
> use_sendfile=NO and no corruption occurs at all; the machine is stable and
> fast.

In the good tradition of proving myself wrong I can reliably create
corrupted files by wget-ting from apache (with sendfile enabled) as
well, so no more TSO after all. No TSO, no corruption.
The same also happens on a different machine with a r8169 (same model).
Tickless kernel makes no difference either. Shot in the dark, but hey..

Holger


