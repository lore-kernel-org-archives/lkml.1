Return-Path: <linux-kernel-owner+w=401wt.eu-S1753521AbZKJKSd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753521AbZKJKSd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 05:18:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753402AbZKJKSc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 05:18:32 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49902 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753400AbZKJKSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 05:18:31 -0500
Date: Tue, 10 Nov 2009 10:19:35 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       linux-kernel@vger.kernel.org, device@lanana.org,
       akpm@linux-foundation.org, rubini@gnudd.com, gregkh@suse.de
Subject: Re: [PATCH 3/3] misc: use a proper range for minor number dynamic
 allocation
Message-ID: <20091110101935.6f5d3353@lxorguk.ukuu.org.uk>
In-Reply-To: <4AF8B4FF.9050405@zytor.com>
References: <1257813017-28598-1-git-send-email-cascardo@holoscopio.com>
	<1257813017-28598-2-git-send-email-cascardo@holoscopio.com>
	<1257813017-28598-3-git-send-email-cascardo@holoscopio.com>
	<4AF8B4FF.9050405@zytor.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > The proposed solution uses the not yet reserved range from 64 to 127. If
> > more devices are needed, we may push 64 to 16.
> > 
> 
> Again, why not push these up above 256?

misc was always intended for one off devices not something creating 40 or
50 misc entries. DLM should be moved out of misc IMHO, or 256+ used for
misc "ranges" such as DLM.

Pushing the existing stuff above minor 256 risks breaking some old setups
