Return-Path: <linux-kernel-owner+w=401wt.eu-S1751599AbZCIXOc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599AbZCIXOc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 19:14:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751700AbZCIXOX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 19:14:23 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:58813 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751458AbZCIXOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 19:14:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=SMnOzpexnfasgEt+ZpMRTEBZ7UfRyPBCWPgFRInOITkeW++VRLAiN12rwpzniYDrpL
         SY+7jNIuQK2l6L8uST6dXBoevhQKX4qpHhYn+E6TD6EIOsR+U5SZLmCGd4QVZGrHrcvo
         BQdYtrmfDU1tbcHRhACvtVnsceZbEU9EvVuEw=
Message-ID: <49B5A2CB.9090802@gmail.com>
Date: Tue, 10 Mar 2009 00:14:19 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-3.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: David Altobelli <david.altobelli@hp.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH] tweak spin logic for hpilo
References: <20090309225651.GA13702@ldl.fc.hp.com>
In-Reply-To: <20090309225651.GA13702@ldl.fc.hp.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9.3.2009 23:56, David Altobelli wrote:
> Change hpilo open and close logic to spin for 10usec between checking device,
> rather than every usec.  Applies to 2.6.29.

Hi,

the description misses a `why' part. In what is this approach better?
