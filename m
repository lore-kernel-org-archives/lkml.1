Return-Path: <linux-kernel-owner+w=401wt.eu-S1755393AbZBINIj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbZBINIj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Feb 2009 08:08:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753798AbZBINIa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Feb 2009 08:08:30 -0500
Received: from mail-fx0-f20.google.com ([209.85.220.20]:62284 "EHLO
	mail-fx0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753778AbZBINI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Feb 2009 08:08:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=eIJNRqDLE6/2JAUuerwmoSDjaV7odxv9AbFjgO/+i2y+McwXkFebqFgHCDXZiK36uf
         gPbuFf8oz0kiGPTkuyaKD8u+ApjXJ5op53LOGD2v4uWpCyG2BB5XLRcEuU+ao7VajDwx
         zXbMemWqBu1MvSRkB+TVnSZIryAjTmAIh0rig=
MIME-Version: 1.0
In-Reply-To: <20090209094014.GE7930@elte.hu>
References: <alpine.DEB.1.10.0902080118480.30802@gandalf.stny.rr.com>
	 <20090209094014.GE7930@elte.hu>
Date: Mon, 9 Feb 2009 14:08:26 +0100
Message-ID: <9fe197cb0902090508v514808c9wc558c18b96ceaa6a@mail.gmail.com>
Subject: Re: [PATCH] ftrace, powerpc64: fix math to calculate offset in TOC
From: Remis Lima Baima <remisbaima@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Arnd Bergmann <arnd@arndb.de>,
       Geoff Levand <geoffrey.levand@am.sony.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have just tried the patch here and everything worked great!
Very well done.

On Mon, Feb 9, 2009 at 10:40 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Steven Rostedt <rostedt@goodmis.org> wrote:
>
>>
>> Paul,
>>
>> I found the bug that was causing large modules to fail in setting
>> up dynamic ftrace. It wound up being a simple math error. To calculate
>> the offset in the TOC, I had used an OR, but the bottom half was
>> a signed extended short, and it should have been an addition.
>> The fix is in my tree below, as well as posted here.
>
> Looks like a .29 candidate?
>
>        Ingo

I agree. A functional ("out-of-the-box") dynamic-ftrace helps quite a lot ;-)


Regards,
Remis
