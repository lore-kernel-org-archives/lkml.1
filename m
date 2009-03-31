Return-Path: <linux-kernel-owner+w=401wt.eu-S1755411AbZCaTz1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411AbZCaTz1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Mar 2009 15:55:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751536AbZCaTzK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Mar 2009 15:55:10 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:39422 "EHLO
	the-village.bc.nu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751466AbZCaTzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Mar 2009 15:55:09 -0400
Date: Tue, 31 Mar 2009 20:27:53 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Ayman KHAMOUMA <ayman.khamouma@st.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: Sysfs with no struc device ?
Message-ID: <20090331202753.4e4fc532@the-village.bc.nu>
In-Reply-To: <000201c9b21c$7f636aa0$663f81a4@par.st.com>
References: <000201c9b21c$7f636aa0$663f81a4@par.st.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.12.12; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Mar 2009 18:19:41 +0200
Ayman KHAMOUMA <ayman.khamouma@st.com> wrote:

> Hi everybody,
> 
> I'm trying to write a module which is supposed to write the state of a pin in a sysfs file.
> As it is neither a char device nor a block device, or anything else, I suposed taht I don't need any struct device...I mau be mistaking...
> So my question is:
> How can I create this file in sysfs without any struct device ?

Wrong question I think - if its a platform device then create a
platform_device for it ..
