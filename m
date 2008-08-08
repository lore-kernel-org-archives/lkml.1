Return-Path: <linux-kernel-owner+w=401wt.eu-S1756179AbYHHJc2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179AbYHHJc2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 05:32:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752890AbYHHJcT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 05:32:19 -0400
Received: from gate.crashing.org ([63.228.1.57]:45359 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752763AbYHHJcS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 05:32:18 -0400
Subject: Re: [PATCH] VT: Restore VT fonts on switch
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Reply-To: benh@kernel.crashing.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org
In-Reply-To: <20080721214025.32bb2629@lxorguk.ukuu.org.uk>
References: <E1KL0tq-0001Wk-Ny@critter.phunnypharm.org>
	 <20080721214025.32bb2629@lxorguk.ukuu.org.uk>
Content-Type: text/plain
Date: Fri, 08 Aug 2008 19:32:04 +1000
Message-Id: <1218187924.24157.338.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-07-21 at 21:40 +0100, Alan Cox wrote:
> On Mon, 21 Jul 2008 15:39:44 -0400
> Matthew Garrett <mjg59@srcf.ucam.org> wrote:
> 
> > Not all X drivers save and restore fonts on text VTs. Add code to the
> > kernel to explicitly save and restore them on VT switches.
> 
> Please explain why this cannot be done by HAL.

To give you a chance to see the console messages during resume
in case something goes wrong before HAL kicks in ? :-)

Ben.


