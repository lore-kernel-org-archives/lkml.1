Return-Path: <linux-kernel-owner+w=401wt.eu-S1756482AbZEWVPs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756482AbZEWVPs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 May 2009 17:15:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753672AbZEWVPk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 23 May 2009 17:15:40 -0400
Received: from casper.infradead.org ([85.118.1.10]:56596 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753531AbZEWVPj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 May 2009 17:15:39 -0400
Date: Sat, 23 May 2009 14:08:30 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Justin Mattock <justinmattock@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: running the kernel without hal= how safe with the cpufreq
Message-ID: <20090523140830.5bff23c3@infradead.org>
In-Reply-To: <dd18b0c30905231129j7ad812e9sf3eee89864b03fb8@mail.gmail.com>
References: <dd18b0c30905231129j7ad812e9sf3eee89864b03fb8@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 23 May 2009 11:29:29 -0700
Justin Mattock <justinmattock@gmail.com> wrote:

> I'm in the process of building a system
> minus hal(since udev 142 explains itself
> in the README),
> Anyways I normally just have
> "ondemand" compiled as the main
> cpufreq module, and have no powermgnt or cpufreq
> userspace tool except or was hal.
> should I be concerned
> without having hal due to things like this in
> ps auxZ

if you use ondemand you don't need anything else; the defaults
are good and in fact very very few people (if anyone) should ever
change the tunables (they're more aimed for the ondemand developers).

Any application that touches these tunables is basically broken ;)

In addition, you should always be safe against hardware breaking,
as long as you don't do things like poke chipset registers to disable
SMM etc, there is thermal protection build into the system.
First it will automatically slow down the CPU (a lot), and if that is
not sufficient/fast enough, the system will shut down before it lets
itself be damaged.



-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
