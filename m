Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757971Ab0BROsl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Feb 2010 09:48:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38255 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757787Ab0BROsg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Feb 2010 09:48:36 -0500
Subject: Re: [PATCH 0/10] Nested SVM fixes (and Win7-64bit bringup)
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
From: Alexander Graf <agraf@suse.de>
In-Reply-To: <4B7D4FBA.2030204@redhat.com>
Date: Thu, 18 Feb 2010 15:48:33 +0100
Cc: Joerg Roedel <joerg.roedel@amd.com>, Marcelo Tosatti <mtosatti@redhat.com>,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <9769FCB3-A4E4-4934-808C-A83ADCC72356@suse.de>
References: <1266493115-28386-1-git-send-email-joerg.roedel@amd.com> <4B7D4FBA.2030204@redhat.com>
To: Avi Kivity <avi@redhat.com>
X-Mailer: Apple Mail (2.1077)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 18.02.2010, at 15:33, Avi Kivity wrote:

> On 02/18/2010 01:38 PM, Joerg Roedel wrote:
>> Hi,
>> 
>> here is a couple of fixes for the nested SVM implementation. I collected these
>> fixes mostly when trying to get Windows 7 64bit running as an L2 guest. Most
>> important fixes in this set make lazy fpu switching working with nested SVM and
>> the nested tpr handling fixes. Without the later fix the l1 guest freezes when
>> trying to run win7 as l2 guest. Please review and comment on these patches :-)
>>   
> 
> Overall looks good.  Would appreciate Alex looking over these as well.

The kmap thing is broken though, right?

Alex