Return-Path: <linux-kernel-owner+w=401wt.eu-S1752824AbZLQXrZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824AbZLQXrZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Dec 2009 18:47:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751477AbZLQXrW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Dec 2009 18:47:22 -0500
Received: from terminus.zytor.com ([198.137.202.10]:56474 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751296AbZLQXrV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Dec 2009 18:47:21 -0500
Message-ID: <4B2AC2E9.50401@zytor.com>
Date: Thu, 17 Dec 2009 15:46:49 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-3.9.b4.fc12 Thunderbird/3.0b4
MIME-Version: 1.0
To: Masami Hiramatsu <mhiramat@redhat.com>
CC: Roland Dreier <rdreier@cisco.com>, Sam Ravnborg <sam@ravnborg.org>,
       mingo@redhat.com, linux-kernel@vger.kernel.org, mmarek@suse.cz,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] Makefile: set LC_CTYPE, LC_COLLATE,	LC_NUMERIC
 to C
References: <4B2A1761.4070904@suse.cz>	<tip-c051346b7db27aaf674b8f3b4955240580b2a58a@git.kernel.org>	<20091217220951.GB4236@merkur.ravnborg.org>	<4B2AB07D.5010007@zytor.com> <4B2AC01E.6090509@redhat.com> <ada8wd141am.fsf@roland-alpha.cisco.com> <4B2AC25E.5050009@redhat.com>
In-Reply-To: <4B2AC25E.5050009@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2009 03:44 PM, Masami Hiramatsu wrote:
> Roland Dreier wrote:
>>
>>  > btw, something went wrong with it...
>>
>>  > make[3]: `scripts/unifdef' ???????
>>
>>  > when I ran with LC_ALL=C, it shows message correctly.
>>
>>  > make[3]: `scripts/unifdef' is up to date.
>>
>> Do you have LANG and/or LC_MESSAGES set?  LC_ALL will override all other
>> locale settings, so hpa explicitly unset it so that the other LC_xxx
>> variables will be used.  But it means your environment's LC_MESSAGES (or
>> LANG if LC_MESSAGES is not set) will be used.
> 
> Actually, I haven't touched it (I just installed Fedora11).
> And I think most of users don't set it too.
> 

Fedora will typically set LANG.  Do:

printenv | egrep '^(LANG|LC_)'

... to verify.

	-hpa
