Return-Path: <linux-kernel-owner+w=401wt.eu-S1751576AbZIMV6k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751576AbZIMV6k (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Sep 2009 17:58:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751036AbZIMV6i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Sep 2009 17:58:38 -0400
Received: from mail-yw0-f174.google.com ([209.85.211.174]:41819 "EHLO
	mail-yw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771AbZIMV6h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Sep 2009 17:58:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=rfiy0IkYJA7kg6Ps1rn24S84v6vbzbTOH/1U80pnTEqmfj9FxfPgK4ToAvt5JF2Ycn
         B6tu3rnhnV3xidM4Fo3sym0dFFHeKY1f42PjqqRbmzwYufsHhAMZDna5ahxtWxP1O7fu
         O+Excntcu/DDw+u3dHLdVa24G28PerV9KKGBU=
MIME-Version: 1.0
In-Reply-To: <94a0d4530909131442h43d0ed1cl9f395f7d38f2c43@mail.gmail.com>
References: <1252870707-4824-1-git-send-email-felipe.contreras@gmail.com> 
	<1252870707-4824-2-git-send-email-felipe.contreras@gmail.com> 
	<1252870707-4824-3-git-send-email-felipe.contreras@gmail.com> 
	<8bd0f97a0909131412v6ba29823ube9aab20302aaca0@mail.gmail.com> 
	<94a0d4530909131442h43d0ed1cl9f395f7d38f2c43@mail.gmail.com>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Sun, 13 Sep 2009 17:58:20 -0400
Message-ID: <8bd0f97a0909131458r8574620pa539876da969eb5f@mail.gmail.com>
Subject: Re: [PATCH 2/5] kbuild: fix warning when domainname is not available
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.
On Sun, Sep 13, 2009 at 17:42, Felipe Contreras
<felipe.contreras@gmail.com> wrote:
> On Mon, Sep 14, 2009 at 12:12 AM, Mike Frysinger <vapier.adi@gmail.com> wrote:
>> On Sun, Sep 13, 2009 at 15:38, Felipe Contreras wrote:
>>> +  if $domain; then
>>
>> is this really correct ?  i think you meant to use:
>> [ -n "$domain" ]
>
> What is the difference?
>
> $domain unset
> test -n "" -> false
> test -> false
>
> $domain is a valid string
> test -n "string" -> true
> test "string" -> true

except that you didnt invoke `test` anywhere.  you're executing the
contents of $domain.
-mike
