Return-Path: <linux-kernel-owner+w=401wt.eu-S1752150AbYHIRDz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150AbYHIRDz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 13:03:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750763AbYHIRDr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 13:03:47 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:18641 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749AbYHIRDr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 13:03:47 -0400
Date: Sat, 9 Aug 2008 19:03:36 +0200
From: Jean Delvare <khali@linux-fr.org>
To: "Fabio Comolli" <fabio.comolli@gmail.com>
Cc: "Bjorn Helgaas" <bjorn.helgaas@hp.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Rene Herman" <rene.herman@keyaccess.nl>,
       "Andrew Morton" <akpm@osdl.org>, "Thomas Renninger" <trenn@suse.de>
Subject: Re: New conflict message in latest GIT
Message-ID: <20080809190336.05e84068@hyperion.delvare>
In-Reply-To: <b637ec0b0808090932l4d21d973we160c145f007da7c@mail.gmail.com>
References: <b637ec0b0807221156x46d550a1h4180d6d624daeeb@mail.gmail.com>
	<200807231256.42743.bjorn.helgaas@hp.com>
	<b637ec0b0807231250g3e5b29eak8fbba41b69816351@mail.gmail.com>
	<20080809181358.5c9da790@hyperion.delvare>
	<b637ec0b0808090932l4d21d973we160c145f007da7c@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Aug 2008 18:32:31 +0200, Fabio Comolli wrote:
> Anyway, as usual linux is not supported at all on this laptop, it came
> with XP. One thing that puzzles me is why bothering adding a
> monitoring chip for which drivers do not exist for any OS?

If you refer to the PC87591: that's a Super-I/O chip, including many
different functions. Hardware monitoring is only one of these
functions. Manufacturers might be interested in some of the other
features and chose this chip because of them. Windows doesn't support
hardware monitoring at all without 3rd party tools anyway, so that's
hardly a decision factor for vendors.

Additionally, on laptops, thermal management is most often done by ACPI
rather than native OS drivers. Maybe the ACPI implementation in your
laptop actually gets the temperature from the PC87591.

-- 
Jean Delvare
