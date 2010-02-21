Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755076Ab0BUJ4x (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Feb 2010 04:56:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34231 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752862Ab0BUJ4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Feb 2010 04:56:51 -0500
Message-ID: <4B810360.7030108@redhat.com>
Date: Sun, 21 Feb 2010 11:56:48 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Joerg Roedel <joerg.roedel@amd.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/11] Nested SVM fixes v2
References: <1266592990-8911-1-git-send-email-joerg.roedel@amd.com>
In-Reply-To: <1266592990-8911-1-git-send-email-joerg.roedel@amd.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/19/2010 05:22 PM, Joerg Roedel wrote:
> Hi,
>
> this is the second version of the KVM fixes queued up while testing
> nested svm with Windows 7 64 bit. Changes to the previous version:
>
> 	* Fixed kunmap bug
> 	* Introduced nested_svm_intercept insteat of
> 	  nested_svm_exit_handled_atomic()
> 	* Added missing patch description
> 	* Added wbinvd/invd skip functions because the instruction
> 	  emulator fails on these instructions (found during Windows 7
> 	  XP mode bringup)
>
> Please review and comment (or apply ;-) these patches.
>    

Applied 1-10, thanks.  11 got a comment.

-- 
error compiling committee.c: too many arguments to function

