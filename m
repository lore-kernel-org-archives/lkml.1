Return-Path: <linux-kernel-owner+w=401wt.eu-S1946152AbXBPUts@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946152AbXBPUts (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Feb 2007 15:49:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1946147AbXBPUts
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 16 Feb 2007 15:49:48 -0500
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:36067 "EHLO
	netops-testserver-3.corp.sgi.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1946152AbXBPUtr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Feb 2007 15:49:47 -0500
Date: Fri, 16 Feb 2007 12:49:46 -0800 (PST)
From: Christoph Lameter <clameter@sgi.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
cc: Andi Kleen <ak@muc.de>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, virtualization@lists.osdl.org,
       xen-devel@lists.xensource.com, Chris Wright <chrisw@sous-sol.org>,
       Zachary Amsden <zach@vmware.com>
Subject: Re: [patch 00/21] Xen-paravirt: Xen guest implementation for
 paravirt_ops interface
In-Reply-To: <20070216022449.739760547@goop.org>
Message-ID: <Pine.LNX.4.64.0702161244380.26718@schroedinger.engr.sgi.com>
References: <20070216022449.739760547@goop.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007, Jeremy Fitzhardinge wrote:

> This patch series implements the Linux Xen guest in terms of the
> paravirt-ops interface.  The features in implemented this patch series

I am thoroughly confused. Maybe that is because I have not been following 
this issue closely but it seems that you are using the paravirt interface 
as an API for Xen code in the guest? I thought the idea of paravirt was to 
have an API that is generic? This patchset seems to be mostly realizing 
Xen specific functionality? How does the code here interact with KVM, 
VMWare and other hypervisors?

