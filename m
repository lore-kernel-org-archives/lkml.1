Return-Path: <linux-kernel-owner+w=401wt.eu-S1758889AbYBXSOZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758889AbYBXSOZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Feb 2008 13:14:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751743AbYBXSOR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Feb 2008 13:14:17 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:21375 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752601AbYBXSOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Feb 2008 13:14:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QOS5IqrZ0WbpbDitLi20T2N5Zz/AtfQnEkTiD5BWLN81NE9BGCmn2RDNIpLb6S7YfPXdZjpG5TGW6syNNDS86NFANomRcqYjHcRsNpjcJNza1Un5K9Q44il7H5lyBrNaJNPNpQU8oZLuIzID8OMDCLXYvw4BcT+bUe8i/z0qdBE=
Message-ID: <4d8e3fd30802241014g503c78a2wc08bd1939657802b@mail.gmail.com>
Date: Sun, 24 Feb 2008 19:14:13 +0100
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Benny Halevy" <bhalevy@panasas.com>
Subject: Re: [PATCH] Change a WARN message in checkpatch
Cc: "Andy Whitcroft" <apw@shadowen.org>,
       "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <47C18AAB.7050503@panasas.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080114232913.2555d392@paolo-desktop>
	 <20080128145605.GI12910@shadowen.org>
	 <4d8e3fd30801280713n7139223fj91adca85c76b60ad@mail.gmail.com>
	 <4d8e3fd30802230538k7be1cc6bja9130e65fc6f5997@mail.gmail.com>
	 <47C18AAB.7050503@panasas.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 24, 2008 at 4:18 PM, Benny Halevy <bhalevy@panasas.com> wrote:
[...]
>  How about:
>  -                               WARN("no space between function name and open parenthesis '('\n" . $herecurr);
>  +                               WARN("there should be no space between function name and open parenthesis '('\n" . $herecurr);

I originally suggested:
+                               WARN("don't put a space between
function name and open parenthesis '('\n" . $herecurr);
but I really prefer your version.

>  The original phrasing can be interpreted like "there is no space between ..." and the correct
>  interpretation should be "there should be no space between ..."

Indeed.

Ciao,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
