Return-Path: <linux-kernel-owner+w=401wt.eu-S1751932AbZGZIAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbZGZIAb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jul 2009 04:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751618AbZGZIAa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Jul 2009 04:00:30 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:13885 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbZGZIA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jul 2009 04:00:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=isKbWyUY4L0CvuCy1vZ4znlCAAHDQrRukZKlpRvQgwTSzasgNP3jZysirO5BheGNby
         boOYo8sUX+89jAove+cyC6QbiOkjKPpHRoV7D0/YFWgK8aG1NG+rsbF8gJWnDR/OGoIV
         jgl8x3YHxQnqwDzqvnp/Dp8Seck4vwQOKqslY=
Message-ID: <4A6C0D1B.4050103@gmail.com>
Date: Sun, 26 Jul 2009 10:00:27 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.8 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Johannes Berg <johannes@sipsolutions.net>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org
Subject: stanse [was: wireless: wl12xx, fix lock imbalance]
References: <1247520266-32007-1-git-send-email-jirislaby@gmail.com> <1247521235.7178.1.camel@johannes.local> <4A5BAABF.9020708@gmail.com> <1247521789.7178.2.camel@johannes.local> <4A5BAC77.9010503@gmail.com> <1247522068.7178.4.camel@johannes.local> <20090718111948.GD27287@elte.hu> <1247916829.1055.24.camel@johannes.local> <20090718161029.GA16343@elte.hu>
In-Reply-To: <20090718161029.GA16343@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/18/2009 06:10 PM, Ingo Molnar wrote:
> this == stanse, the static code analyzing thing Jiri mentioned he is 
> working on. The webpage says it will be under the GPL - that's good. 
> Jiri, any release date for the source code?

Sorry for the delay. We are currently rewriting the core: we added
interprocedural analysis and some false-positives killers. We also
merged thread-checker (it can catch (not only) circular lock deps like
in [1]). We are finishing, but it needs some testing, so I would say in
about a month.

[1] http://lkml.indiana.edu/hypermail/linux/kernel/0904.1/03221.html
