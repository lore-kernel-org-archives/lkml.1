Return-Path: <linux-kernel-owner+w=401wt.eu-S1756207AbZDVUbU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207AbZDVUbU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 16:31:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753142AbZDVUbI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 16:31:08 -0400
Received: from gw.goop.org ([64.81.55.164]:39072 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095AbZDVUbH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 16:31:07 -0400
Message-ID: <49EF7E85.7040104@goop.org>
Date: Wed, 22 Apr 2009 13:31:01 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: joseph.cihula@intel.com, linux-kernel@vger.kernel.org, mingo@elte.hu,
       arjan@linux.intel.com, chrisw@sous-sol.org, jmorris@namei.org,
       jbeulich@novell.com, peterm@redhat.com, gang.wei@intel.com,
       shane.wang@intel.com
Subject: Re: [RFC v2][PATCH 1/1] intel_txt: Intel(R) TXT and tboot kernel
 support
References: <49D1A6AB.5090808@intel.com> <87d4baqnxy.fsf@basil.nowhere.org>
In-Reply-To: <87d4baqnxy.fsf@basil.nowhere.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> This means it explodes with paravirt, right? Do you have a check early
> for that?
>   

The tboot stuff should only be run on bare hardware; if there's 
virtualization under the kernel, then TXT should be happening at that level.

    J
