Return-Path: <linux-kernel-owner+w=401wt.eu-S1757495AbZBSXGP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757495AbZBSXGP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Feb 2009 18:06:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754983AbZBSXF7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 19 Feb 2009 18:05:59 -0500
Received: from rv-out-0506.google.com ([209.85.198.235]:28051 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754889AbZBSXF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Feb 2009 18:05:58 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :content-type:content-transfer-encoding;
        b=FxHyAKcFRmIPjpyEul54I4zFtIFLSwtjutna3TEpZeFyHG04Ilfi9gzKncUasq+Tzg
         h3eUzyiGdXb9tlKYckfGdac9zbb8OdW0VFTBeDrXeref6SSWCX97t29KlNdInUlbpSRr
         NemMUt9dFTZmHnCNnFD0ea2/pauy/PAMT0oUs=
Message-ID: <499DE5CE.3030700@gmail.com>
Date: Thu, 19 Feb 2009 15:05:50 -0800
From: John Daiker <daikerjohn@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1b3pre) Gecko/20090219 Lightning/1.0pre Shredder/3.0b3pre
MIME-Version: 1.0
To: apw@canonical.com
CC: linux-kernel@vger.kernel.org, daikerjohn@gmail.com
Subject: checkpatch.pl stalls on net/decnet/dn_fib.c
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy,

Was running checkpatch.pl on the entire tree today (because my disk 
loves to get thrashed like that...)  Found what seems to be a stall/hang 
while running checkpatch.  I know nothing of the internal workings of 
checkpatch.pl, but hope that you're able to sniff this one out!

./scripts/checkpatch.pl --file ./net/decnet/dn_fib.c  --debug values=9 
types=9 possible=9 attr=9

--snip--
51 > . #define endfor_fib_info() }
51 > EEEEEEEEEEEEEEEEEEEEEEEEENNNEE
51 >  _____________________________


<E> <E> <_>WS(
)
52 > .
52 > EEE
52 >  __
  #define for_nexthops(fi) { int nhsel; const struct dn_fib_nh *nh;\

<E> <E> <_>WS( )
<E> <E> <_>DEFINE(#define for_nexthops,()
<EE> <E> <N>PAREN('(')
<EEN> <N> <_>IDENT(fi)
<EEN> <V> <_>PAREN(')') -> N
<EE> <N> <_>WS( )
<EE> <N> <_>END({)
<EE> <E> <_>WS( )
<EE> <E> <_>DECLARE(int )
<EE> <T> <_>IDENT(nhsel)
<EE> <V> <_>END(;)
<EE> <E> <_>WS( )
<EE> <E> <_>DECLARE(const struct dn_fib_nh *)
<EE> <T> <_>IDENT(nh)
<EE> <V> <_>END(;)
<EE> <E> <_>PRECONT(\
)
53 > . #define for_nexthops(fi) { int nhsel; const struct dn_fib_nh *nh;\
53 > EEEEEEEEEEEEEEEEEEEEEENVVNNEETTTTVVVVVEETTTTTTTTTTTTTTTTTTTTTTTTVVEEE
53 >  ____________________________________________________________________
HANGHANGHANGHANG
--snip--

Hope this helps!  Let me know if I can assist in debugging at all.

Thanks,
John Daiker
