Return-Path: <linux-kernel-owner+w=401wt.eu-S1755490AbYATSh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755490AbYATSh0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jan 2008 13:37:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754718AbYATShR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 20 Jan 2008 13:37:17 -0500
Received: from gw.goop.org ([64.81.55.164]:52830 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754470AbYATShP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jan 2008 13:37:15 -0500
Message-ID: <479394D9.50104@goop.org>
Date: Sun, 20 Jan 2008 10:37:13 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: xming <xmingske@gmail.com>
CC: linux-kernel@vger.kernel.org, Xen-devel <xen-devel@lists.xensource.com>
Subject: Re: Cannot boot xen DomU > 2.6.23.1
References: <519a8b110801170813h96b8f2by795e6d8b72a00ba4@mail.gmail.com>	 <478F8D22.60004@goop.org>	 <519a8b110801171113y20a3bedfg446e29a30712a26d@mail.gmail.com>	 <4790561E.9040508@goop.org>	 <519a8b110801180438l389ec1d6t7b888b8c78d59dd8@mail.gmail.com>	 <4790D187.8050000@goop.org>	 <519a8b110801180856o7757889as47106fd3eabcc0de@mail.gmail.com>	 <4790E13D.5040603@goop.org> <519a8b110801200508l1fb3dee9ha197f3fc76ccac69@mail.gmail.com>
In-Reply-To: <519a8b110801200508l1fb3dee9ha197f3fc76ccac69@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

xming wrote:
> ok I have done some of them, but I still don't know what I should be looking
> at. Do you mean code related to xen or code related to have_vcpu_info_placement?
> Please be patient with me :)
>
> I just paste some of the result (around those addresses) here:
>   

Thanks, that answers that particular question; the vcpu is blocked 
waiting for something to happen, which probably means it missed the 
event which was supposed to wake it up.  Why is another question.  At 
least there's a workaround, and that workaround gives me some clue where 
to look.

BTW, is it an SMP or UP domain?   Does it make a difference?

>> OK, good.  I Didn't Break It (tm) ;)
>>     
>
> So no fix from you? :)
>   

Maybe when I have nothing else to do.

    J
