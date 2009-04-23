Return-Path: <linux-kernel-owner+w=401wt.eu-S1757812AbZDWLPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757812AbZDWLPt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Apr 2009 07:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757302AbZDWLPi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 23 Apr 2009 07:15:38 -0400
Received: from mx2.redhat.com ([66.187.237.31]:46794 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751948AbZDWLPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Apr 2009 07:15:38 -0400
Message-ID: <49F04DD3.8020705@redhat.com>
Date: Thu, 23 Apr 2009 13:15:31 +0200
From: Gerd Hoffmann <kraxel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090324 Fedora/3.0-2.1.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Peter Hanzel <hanzelpeter@gmail.com>
CC: linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net
Subject: Re: DRM KMS + intel fb
References: <7398C9BACDA74507AA9FCCCE4847C5A4@avitech.sk>
In-Reply-To: <7398C9BACDA74507AA9FCCCE4847C5A4@avitech.sk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/09 12:12, Peter Hanzel wrote:
> Hello.
>
> I am watching the KMS in DRM development. And now i want to try kernel
> modesetting with framebuffer console.
> I am only using console framebuffer. How it works with DRM KMS.

Just works.  The kms code supports the fb interface.

> Suppose I compile DRM i1915 with KMS. How can I swich video mode on
> start  and than from user space.

Loading the driver switches to the native resolution of the lcd monitor 
connected and runs a fbcon on it.  Didn't try to switching modes later.

HTH,
   Gerd

