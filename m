Return-Path: <linux-kernel-owner+w=401wt.eu-S1756120Ab0A1J1E@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756120Ab0A1J1E (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jan 2010 04:27:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755963Ab0A1J1D
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Jan 2010 04:27:03 -0500
Received: from mail-iw0-f201.google.com ([209.85.223.201]:64480 "EHLO
	mail-iw0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755388Ab0A1J1A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jan 2010 04:27:00 -0500
X-Greylist: delayed 473 seconds by postgrey-1.27 at vger.kernel.org; Thu, 28 Jan 2010 04:27:00 EST
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=Jxxd2aBbrzR/jypYGXLCH/v2eDBIEqiK01izZ9lD6RJ2oeO+93I5DXYD1E28f55GRO
         bghJMSJZEQYsSY6CHl1UMOydGiy+KI/IL5TiDcEU+9FeN1Q5KEAhaIxh+XYNpwE1osE1
         MKu2QWfNhqe0Be1whbZQCXuCYNTGAwRYYZ7lo=
MIME-Version: 1.0
Date: Thu, 28 Jan 2010 11:19:07 +0200
Message-ID: <b6fcc0a1001280119t1394d956paa4865c078b52c9f@mail.gmail.com>
Subject: Re: PROBLEM: reproducible crash KVM+nf_conntrack all recent 2.6 
	kernels
From: Alexey Dobriyan <adobriyan@gmail.com>
To: jonathan@jonmasters.org
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> RIP: 0010:[<ffffffff813b4115>]  [<ffffffff813b4115>] destroy_conntrack+0x82/0x114

Rebuild kernel with CONFIG_DEBUG_INFO=y.
Double sure conntracking is compiled-in.
Then run

    addr2line -e vmlinux $RIP

it will tell exact line where kernel is oopsing.
