Return-Path: <linux-kernel-owner+w=401wt.eu-S1752898AbYLUWEK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898AbYLUWEK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Dec 2008 17:04:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751412AbYLUWDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Dec 2008 17:03:55 -0500
Received: from styx.suse.cz ([82.119.242.94]:37508 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751367AbYLUWDy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Dec 2008 17:03:54 -0500
Date: Sun, 21 Dec 2008 23:03:53 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>
cc: Parag Warudkar <parag.lkml@gmail.com>,
       Anssi Hannula <anssi.hannula@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>, linux-input@vger.kernel.org,
       linux-usb@vger.kernel.org
Subject: Re: [PATCH] USBHID: Make Boot Protocol drivers depend on EMBEDDED
In-Reply-To: <20081221140200.40c1fec1.akpm@linux-foundation.org>
Message-ID: <alpine.LNX.1.10.0812212302400.26265@jikos.suse.cz>
References: <f7848160812201911k7988221asd095ce873fd8105f@mail.gmail.com> <20081220221253.e09b1b1f.akpm@linux-foundation.org> <f7848160812202226w1f930c86vfd17a2b0163bfc56@mail.gmail.com> <494E20F7.7050106@gmail.com> <f7848160812210717w5e5cc7a2uc5571710f755ec99@mail.gmail.com>
 <alpine.LRH.1.10.0812211824350.11630@twin.jikos.cz> <alpine.DEB.2.00.0812211441300.7101@parag-desktop> <alpine.LNX.1.10.0812212247090.26265@jikos.suse.cz> <20081221140200.40c1fec1.akpm@linux-foundation.org>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 21 Dec 2008, Andrew Morton wrote:

> > So do I get it right that the only reason of the problem you were 
> > seeing was that in the 2.6.27 kernel you have compiled usbhid module, 
> > which was then used for driving your mouse,but in 2.6.28-rcX you 
> > compiled and used 'usbmouse' instead, and therefore this is not a 
> > regression?
> Shouldn't usbmouse support two-dimensional mice as well?

Yup, but that's a separate issue on my TODO. I first want to know whether 
this is a regression or not.

Thanks,

-- 
Jiri Kosina
SUSE Labs
