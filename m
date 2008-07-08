Return-Path: <linux-kernel-owner+w=401wt.eu-S1755402AbYGHBdc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755402AbYGHBdc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 21:33:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755403AbYGHBdK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 21:33:10 -0400
Received: from smtp-out.google.com ([216.239.33.17]:39486 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753896AbYGHBdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 21:33:08 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=received:message-id:date:from:to:subject:cc:in-reply-to:
	mime-version:content-type:content-transfer-encoding:
	content-disposition:references;
	b=e837uG95vd0APuaHt3s43+BPtvymyVgdlrBhOA6cSD/Ah0xSCP3rGzSAdPu0jmcqM
	Ewf65wRolAFYK0Ic84+EA==
Message-ID: <6599ad830807071832j42a20faak62c5cdc98aca2d2@mail.gmail.com>
Date: Mon, 7 Jul 2008 18:32:58 -0700
From: "Paul Menage" <menage@google.com>
To: "Li Zefan" <lizf@cn.fujitsu.com>
Subject: Re: [PATCH 1/2] devcgroup: always show unsigned major/minor num
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       "Pavel Emelianov" <xemul@openvz.org>
In-Reply-To: <4872C299.8060207@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <486F0918.5090707@cn.fujitsu.com>
	 <6599ad830807071213u7334cafanc6f2a0b7c4f53ba2@mail.gmail.com>
	 <4872C299.8060207@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 7, 2008 at 6:27 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>>> @@ -254,7 +254,7 @@ static void set_majmin(char *str, unsigned m)
>>>        if (m == ~0)
>>>                sprintf(str, "*");
>>
>> Can't this just be strcat(str, "*")?
>>
>
> No, but it can be strcpy(str, "*").

Oops, yes, that's what I should have put ...

Paul
