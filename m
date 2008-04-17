Return-Path: <linux-kernel-owner+w=401wt.eu-S934475AbYDQQKm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934475AbYDQQKm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2008 12:10:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933833AbYDQQKK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Apr 2008 12:10:10 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43147 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934190AbYDQQKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2008 12:10:07 -0400
Message-ID: <48077550.1080105@zytor.com>
Date: Thu, 17 Apr 2008 12:05:36 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: "Serge E. Hallyn" <serue@us.ibm.com>
CC: sukadev@us.ibm.com, Andrew Morton <akpm@osdl.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Containers <containers@lists.osdl.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]: Factor out PTY index allocation
References: <20080416221723.GB7112@us.ibm.com> <20080417154241.GC14215@sergelap.austin.ibm.com>
In-Reply-To: <20080417154241.GC14215@sergelap.austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Serge E. Hallyn wrote:
> Quoting sukadev@us.ibm.com (sukadev@us.ibm.com):
>> We noticed this while working on pts namespaces and believe this might
>> be an useful change even as we rework our pts/device namespace approach.
>>
>> ---
>>
>> From: Sukadev Bhattiprolu <sukadev@us.ibm.com>
>> Subject: [PATCH]: Factor out PTY index allocation
>>
>> Factor out the code used to allocate/free a pts index into new interfaces,
>> devpts_new_index() and devpts_kill_index().  This localizes the external
>> data structures used in managing the pts indices.
>>
>> Signed-off-by: Sukadev Bhattiprolu <sukadev@us.ibm.com>
>> Signed-off-by: Serge Hallyn<serue@us.ibm.com>
>> Signed-off-by: Matt Helsley<matthltc@us.ibm.com>
> 
> No traces of devpts namespaces here, so I assume this should be
> non-offensive and fine for inclusion.
> 

Acked-by: H. Peter Anvin <hpa@zytor.com>
