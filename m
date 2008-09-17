Return-Path: <linux-kernel-owner+w=401wt.eu-S1755226AbYIQRpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755226AbYIQRpf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 13:45:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754315AbYIQRpY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 13:45:24 -0400
Received: from mail.lang.hm ([64.81.33.126]:47578 "EHLO bifrost.lang.hm"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753963AbYIQRpX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 13:45:23 -0400
Date: Wed, 17 Sep 2008 10:46:07 -0700 (PDT)
From: david@lang.hm
X-X-Sender: dlang@asgard.lang.hm
To: Casey Schaufler <casey@schaufler-ca.com>
cc: Kentaro Takeda <takedakn@nttdata.co.jp>,
       linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Toshiharu Harada <haradats@nttdata.co.jp>
Subject: Re: [PATCH] Introduce new LSM hooks where vfsmount is available.
In-Reply-To: <48D080D1.5060405@schaufler-ca.com>
Message-ID: <alpine.DEB.1.10.0809171043520.22392@asgard.lang.hm>
References: <48C65E9D.3070106@nttdata.co.jp> <5fb14edc0809090902m32431bf6yf518a457e410764d@mail.gmail.com> <20080910134540.45ec1272.akpm@linux-foundation.org> <48C877DE.4040402@nttdata.co.jp> <48D06865.8070602@nttdata.co.jp>
 <48D080D1.5060405@schaufler-ca.com>
User-Agent: Alpine 1.10 (DEB 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Sep 2008, Casey Schaufler wrote:

> Kentaro Takeda wrote:
>> TOMOYO Linux needs method for calculating pathname in LSM module.
>> However, we have received comment from Al Viro, the vfs maintainer,
>> that adding vfsmount parameter to vfs helper functions (and LSM hooks)
>> is not preferable. We have asked some people (including Al), and we
>> came back to the most straightforward approach; adding new LSM hooks
>> where vfsmount is available.
>> 
>> The attached patch introduces several new LSM hooks TOMOYO Linux
>> needs. It has less impact to existing LSM module and no impact to vfs
>> helper functions. Please review it.
>> 
>> Regards,
>>
>> 
> As always, the community will be eager to see the code that makes
> use of these hooks.

you can bet that if these hooks are accepted, AppArmor and the various 
other LSMs that have not been accepted becouse of the problems they have 
dealing with paths will switch to using the 'approved' hooks.

so there are several bodies of code that have already been published that 
would want to use hooks like these if they are available.

David Lang
