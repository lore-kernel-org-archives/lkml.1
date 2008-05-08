Return-Path: <linux-kernel-owner+w=401wt.eu-S1762345AbYEHOQe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762345AbYEHOQe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 10:16:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753067AbYEHOQ0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 10:16:26 -0400
Received: from gate.crashing.org ([63.228.1.57]:53292 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118AbYEHOQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 10:16:25 -0400
Cc: lkml List <linux-kernel@vger.kernel.org>,
       "linuxppc-dev@ozlabs.org list" <linuxppc-dev@ozlabs.org>
Message-Id: <5DD68A6B-45FD-4163-BDF5-356C70A00676@kernel.crashing.org>
From: Kumar Gala <galak@kernel.crashing.org>
To: Sam Ravnborg <sam@ravnborg.org>
In-Reply-To: <20080505204449.GA9446@uranus.ravnborg.org>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v919.2)
Subject: Re: How to link a .o with all modules
Date: Thu, 8 May 2008 09:16:10 -0500
References: <6C8AB345-2DA0-460D-B7C8-262463247DDE@kernel.crashing.org> <20080504192434.GA23752@uranus.ravnborg.org> <D346E2E4-26C3-482E-ABBF-AF1EE97E91CD@kernel.crashing.org> <20080505204449.GA9446@uranus.ravnborg.org>
X-Mailer: Apple Mail (2.919.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On May 5, 2008, at 3:44 PM, Sam Ravnborg wrote:

>>>
>>>
>>> Let me know if this does address your question.
>>
>> The problem is MODPOST complains about undefined symbols:
>>
>>  MODPOST 24 modules
>> ERROR: "_restgpr_20_x" [net/key/af_key.ko] undefined!
>> ERROR: "_restgpr_25_x" [net/key/af_key.ko] undefined!
>> ERROR: "_restgpr_30_x" [net/key/af_key.ko] undefined!
>
> I need a bit more context to try to analyse this.
> Where did you expect _restgpr_20_x to be defined.
> If in vmlinux then were they present in the
> Module.symvers file?

No they aren't there since we I'm not EXPORT_SYMBOL() them.  Should I  
also be doing EXPORT_SYMBOL?

> If in the linked in .o file - could you
> see the symbols using objdump.

Yes.

readelf -a:

...
Symbol table '.symtab' contains 113 entries:
    Num:    Value  Size Type    Bind   Vis      Ndx Name
...
      5: 00000000     0 FUNC    GLOBAL DEFAULT    1 _savegpr_14
      6: 00000000     0 FUNC    GLOBAL DEFAULT    1 _save32gpr_14
...
>
>
> etc.
>
> Sorry - not much help right away.
>
> PS. Travelling - do not expect responses until the
> weekend.

np.
>
>
> 	Sam

