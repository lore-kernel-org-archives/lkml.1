Return-Path: <linux-kernel-owner+w=401wt.eu-S933722AbYBCOCz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933722AbYBCOCz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2008 09:02:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753895AbYBCOCq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 3 Feb 2008 09:02:46 -0500
Received: from smtp-100-sunday.nerim.net ([62.4.16.100]:62764 "EHLO
	kraid.nerim.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753462AbYBCOCp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2008 09:02:45 -0500
Date: Sun, 3 Feb 2008 15:02:38 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Michael E Brown <Michael_E_Brown@dell.com>
Cc: Markus Rechberger <markus.rechberger@amd.com>, Matt_Domsch@dell.com,
       Jos?? Luis Tall??n <jltallon@adv-solutions.net>,
       Douglas_Warzecha@dell.com, Abhay_Salunke@dell.com,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>
Subject: Re: 2.6.24 breaks BIOS updates on all Dell machines
Message-ID: <20080203150238.2e9c6704@hyperion.delvare>
In-Reply-To: <20080129190924.GB8786@humbolt.us.dell.com>
References: <20080129064415.GA8822@suse.de>
	<479F3F60.8050108@amd.com>
	<20080129190417.GA15410@speedy.student.utwente.nl>
	<20080129190924.GB8786@humbolt.us.dell.com>
X-Mailer: Sylpheed-Claws 2.5.5 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Tue, 29 Jan 2008 13:09:25 -0600, Michael E Brown wrote:
> On Tue, Jan 29, 2008 at 08:04:17PM +0100, Sytse Wielinga wrote:
> > I've created the simple patch below. I have no idea if it actually works,
> > though, as I don't appear to have any hardware for which a linux driver
> > supports firmware loading. Please comment.
> 
> You can test this rather easily. Simply modprobe the "dell_rbu" driver.
> You dont need any special hardware, it should load on any machine. After
> you have loaded it, check the sysfs path to see if it has the correct
> path (or some symlink thereof):
> 
> GOOD: /sys/class/firmware/dell_rbu/   
> BAD : /sys/class/firmware/firmware-dell_rbu/loading

This doesn't actually work for me. Loading the dell_rbu driver on a
non-Dell system doesn't create anything under /sys/class/firmware.

-- 
Jean Delvare
