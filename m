Return-Path: <linux-kernel-owner+w=401wt.eu-S1753325AbZC0Va3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325AbZC0Va3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Mar 2009 17:30:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751434AbZC0VaV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Mar 2009 17:30:21 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:63198 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863AbZC0VaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Mar 2009 17:30:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=ZgnpncpzqJ3FuW/pATE8tvsummIsKLSC6xwwGvXoQ7elQgIWMwJx6voQhdHHrW3Eok
         qDoKULIz6R00c2We0b/D+mN7EmU/LCZgMnyXdJhez0Ns5ialWUkO8yfmMVXJ8V9hpgFZ
         aOtwDXz0fAiTLsvQDuxUgRgpwbGBz/tJGHgJ8=
Message-ID: <49CD4565.2090509@gmail.com>
Date: Fri, 27 Mar 2009 22:30:13 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-8.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: Fabio Coatti <cova@ferrara.linux.it>
CC: linux-kernel@vger.kernel.org
Subject: Re: server lockups - task blocked for more than 120 seconds
References: <200903261543.35383.cova@ferrara.linux.it>
In-Reply-To: <200903261543.35383.cova@ferrara.linux.it>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2009 03:43 PM, Fabio Coatti wrote:
> Hi all, as we are experiencing several lockups on productions servers, we 
> activated some kernel debug options in order to look into causes. One thing 
> that we have found on kernel log is the message " task blocked for more than 
> 120 seconds", just before the lockup.I don't know if this is a symptom useful 

Hmm, could you try to turn on LOCKDEP?
