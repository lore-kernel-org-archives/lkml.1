Return-Path: <linux-kernel-owner+w=401wt.eu-S1756024AbXJAQsG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756024AbXJAQsG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2007 12:48:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751657AbXJAQr4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 1 Oct 2007 12:47:56 -0400
Received: from mail.suse.de ([195.135.220.2]:40589 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751580AbXJAQrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2007 12:47:55 -0400
From: Andi Kleen <andi@firstfloor.org>
Organization: -
To: Joerg Roedel <joro@8bytes.org>
Subject: Re: [PATCH] [19/50] Experimental: detect if SVM is disabled by BIOS
Date: Mon, 1 Oct 2007 18:47:50 +0200
User-Agent: KMail/1.9.6
Cc: patches@x86-64.org, linux-kernel@vger.kernel.org
References: <200709221231.836138000@suse.de> <20070921223218.22A8D13DCD@wotan.suse.de> <20070922091708.GD8998@8bytes.org>
In-Reply-To: <20070922091708.GD8998@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710011847.50533.andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 22 September 2007 11:17:08 Joerg Roedel wrote:
> I don't think we need this patch. When SVM is disabled KVM will tell on
> module load. 

The point is that people often want to know in advance (before they
even try to use KVM or Xen) if their CPU and BIOS supports this.

> Further with SVM-lock it will be possible to re-enable SVM 
> even if it was disabled by BIOS using a key. In this case the user of
> SVM has to clear the capability bit you set in this patch for all cpus.

Not sure I follow you. Can you clarify?  What exactly needs to be
done to do a full non reversible lock? 

-Andi

