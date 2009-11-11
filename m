Return-Path: <linux-kernel-owner+w=401wt.eu-S1759574AbZKKWs2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759574AbZKKWs2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 17:48:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759517AbZKKWs1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 17:48:27 -0500
Received: from mail-yx0-f187.google.com ([209.85.210.187]:43295 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759509AbZKKWs0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 17:48:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=EV3vmgFVTf10LJqTsp+ma5rBatlca7oIcDjBjrVUaRF27D2YmuilXSkDJ42jIPCt5y
         Vn//Rwn7wFl4HTRpVNOtqA+ohvAgG5PkK5hnqtpvO9yhgw4K4De9J/j7PH/Fgg+m0vXy
         p+h83GC6WNiXBdyW21dPG7DVugPE9CIA4ZuSI=
MIME-Version: 1.0
In-Reply-To: <200911112305.54824.elendil@planet.nl>
References: <81bfc67a0910310721p21046931o9b512cfd0a8a7acb@mail.gmail.com>
	 <81bfc67a0911111219m1efff30cr3186987f9dbb3d4d@mail.gmail.com>
	 <878wecka3g.fsf@basil.nowhere.org>
	 <200911112305.54824.elendil@planet.nl>
Date: Wed, 11 Nov 2009 17:48:30 -0500
Message-ID: <81bfc67a0911111448q2e7938fcq18adf2454d6bc8f1@mail.gmail.com>
Subject: Re: large packet loss take2 2.6.31.x
From: Caleb Cushing <xenoterracide@gmail.com>
To: Frans Pop <elendil@planet.nl>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 11, 2009 at 5:05 PM, Frans Pop <elendil@planet.nl> wrote:
> On Wednesday 11 November 2009, Andi Kleen wrote:
>> Caleb Cushing <xenoterracide@gmail.com> writes:
>> >> I'm attaching the bisection log and a 'good' dmesg output.
>> >>
>> >> c9fb3ded7a8a6769f3bcb3ef3d9aed61d3e376a9 is the first bad commit
>>
>> Just gives fatal: bad object c9fb3ded7a8a6769f3bcb3ef3d9aed61d3e376a9
>> here on a standard Linus linux-2.6 tree.
>
> Looks to be a commit from a stable update:
>
> commit c9fb3ded7a8a6769f3bcb3ef3d9aed61d3e376a9
> Author: Alan Stern <stern@rowland.harvard.edu>
> Date:   Tue Sep 1 11:38:34 2009 -0400
>
>    usb-serial: change referencing of port and serial structures
>
>    commit 41bd34ddd7aa46dbc03b5bb33896e0fa8100fe7b upstream.
>
> Cheers,
> FJP
>

yeah it is. it's from greg kroah-hartman's tree.
-- 
Caleb Cushing

http://xenoterracide.blogspot.com
