Return-Path: <linux-kernel-owner+w=401wt.eu-S1757952AbXJAWOL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757952AbXJAWOL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 18:14:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753578AbXJAWN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 18:13:58 -0400
Received: from 8bytes.org ([88.198.83.132]:47290 "EHLO 8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753467AbXJAWN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 18:13:58 -0400
Date: Tue, 2 Oct 2007 00:13:57 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Andi Kleen <ak@suse.de>
Cc: patches@x86-64.org, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [patches] [PATCH] [19/50] Experimental: detect if SVM is disabled by BIOS
Message-ID: <20071001221357.GA6921@8bytes.org>
References: <200709221231.836138000@suse.de> <200710011847.50533.andi@firstfloor.org> <20071001201222.GB1404@8bytes.org> <200710012345.22851.ak@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200710012345.22851.ak@suse.de>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2007 at 11:45:22PM +0200, Andi Kleen wrote:
> 
> 
> > feature flag does not disappear when its disabled. But because with CPUs
> > having the SVM-lock feature it can be re-enabled in a secure way under
> > some circumstances
> 
> Who would reenable it in what circumstances?

I plan to implement the ability to re-enable it into the SVM module of KVM.
The key required for this will be passed as a module parameter.

Joerg
