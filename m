Return-Path: <linux-kernel-owner+w=401wt.eu-S1755370AbYCLWur@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370AbYCLWur (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 18:50:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751780AbYCLWui
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 18:50:38 -0400
Received: from nf-out-0910.google.com ([64.233.182.191]:4804 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751970AbYCLWui (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 18:50:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dc1E/nUNUvP2NcVbPTWNUwxN9QJOupHY0D6uEEB5v+VNlrgCZgRZclpLWkSijsh2LVNm03SJyvj8o0u/EYmKQBlu1ES116/r1IRTr1DwEfyKRPIrURp90Hhst37vO4/YucPtkmUY6DUIs3PoqNutYeoJ4AMACDITPRHZgeScVWE=
Message-ID: <3d8471ca0803121550g2a88a744nffdde7dff4ce9f95@mail.gmail.com>
Date: Wed, 12 Mar 2008 23:50:35 +0100
From: "Guillaume Chazarain" <guichaz@gmail.com>
To: "Jiri Slaby" <jirislaby@gmail.com>
Subject: Re: /proc/loadavg: total number of processes is wrong?
Cc: "Chuck Ebbert" <cebbert@redhat.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <47D85CAC.90402@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <47D85916.5080203@redhat.com> <47D85CAC.90402@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/12/08, Jiri Slaby <jirislaby@gmail.com> wrote:
> I guess you need to ps max, but it won't match exactly anyway.

With ps axh you can get it:

[g ~]$ cat /proc/loadavg|cat
0.45 0.35 0.24 3/192 12463
[g ~]$ ps Haxh|wc -l
192


-- 
Guillaume
