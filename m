Return-Path: <linux-kernel-owner+w=401wt.eu-S1755390AbYHMUA4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390AbYHMUA4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2008 16:00:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752021AbYHMUAs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Aug 2008 16:00:48 -0400
Received: from fk-out-0910.google.com ([209.85.128.191]:65346 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752003AbYHMUAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2008 16:00:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=p9sCUlRnG0pHY/BIt0AW4ec4LCj4x7WxCQTBfhci5OetLgufDT2QzGjhCfdHucykve
         X28ZQ9bG+gvM8DSRaM4lQXFbG7RRvzx4vl8ESE/84R0SZ1Q3qip7TF2F4kuLedAbJSuH
         HUexnSiIk4LjOncrcIOknDBB+LgMgH5klGcP8=
Message-ID: <48A33D67.5090603@gmail.com>
Date: Wed, 13 Aug 2008 16:00:39 -0400
From: 7v5w7go9ub0o <7v5w7go9ub0o@gmail.com>
User-Agent: Thunderbird 2.0.0.16 (X11/20080707)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: libmalware.so: Dazuko Linux/BSD On-Access scanning and control
References: <48A32CAC.1030605@gmail.com> <87bpzw1zbo.fsf@basil.nowhere.org>
In-Reply-To: <87bpzw1zbo.fsf@basil.nowhere.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> 7v5w7go9ub0o <7v5w7go9ub0o@gmail.com> writes:
> 
>> (FYI. Dazuko may have trailblazed some of the issues now under
>> discussion re: libmalware.so. It has worked well for me.
> 
> Against what exactly did it protect you? Please give a concrete example.
> 
> -Andi
> 

1. This came in a few minutes ago:

Aug 13 14:56:31 tux antivir[6381]: AntiVir ALERT: [EML/FakeLink.F] 
/jail/tbird/root/.thunderbird/0r2957kg.default/Mail/L
ocal Folders/Junk.XXX <<< Contains detection pattern of EML/FakeLink.F 
in EML form

2. I have not retained the logs of "suspicious scripts" in my browser, 
but have come across perhaps 4 blocked scripts within the last month. 
Admittedly at dodgy sites.

XSS attacks are platform independent, and are a significant concern.


Please note that when I say it has worked well for me, I am not saying 
that it has saved my bacon! :-)

1. I am referring to the mechanics of having the Kernel/userland app 
stop processing when it finds a malware signature or heuristic detection.

2. Am also referring to the totally manageable (IMHO) overhead.

I've mentioned my experience with Dazuko/antivir only because it may be 
useful to the ongoing discussion about the nature of libmalware.so.

3. I am frankly waiting for a bug to get into my upstream distribution 
chain - through a hijacking or some wonderful DNS prank - at which point 
I ..hope.. a signature or heuristic will block my root-enabled make install.

4. Again, my hope for libmalware.so/dazuko is a realtime 
integrity-management link.






