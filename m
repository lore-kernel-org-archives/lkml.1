Return-Path: <linux-kernel-owner+w=401wt.eu-S934440AbZLGEC6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934440AbZLGEC6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Dec 2009 23:02:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933180AbZLGEC5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 6 Dec 2009 23:02:57 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:44303 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933157AbZLGEC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Dec 2009 23:02:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=iM3SnVyMFyiyzL2heXSTU6SeDYLqkJ2u/qY9Y7Ufnsv3DAyykgA4WtDJEv5X9duHkw
         Gz4UOb8gufquHYpuylOC9OBeTEcuzwlSFcRkPKcTR4mp/atg8E23dQjZeIOOhbpHk+gD
         RmSzZyCm0i/KnLlnvhZzQ3a7eX3Ip3PRZkc/U=
Date: Mon, 7 Dec 2009 05:02:57 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, Tom Zanussi <tzanussi@gmail.com>,
       Steven Rostedt <srostedt@redhat.com>
Subject: Re: [PATCH 1/2] Does raw_field_ptr() supports __data_loc?
Message-ID: <20091207040255.GA5262@nowhere>
References: <20091115022135.GA5427@nowhere> <1260156884-8474-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1260156884-8474-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07, 2009 at 12:34:43PM +0900, Hitoshi Mitake wrote:
> VERY very sorry for my long silence...
> 
> Please don't commit this patch, Ingo.
> This patch is required to test the next patch for perf lock.
> 
> I have a question for Steven Rostedt and Tom Zanussi.
> Does current raw_field_ptr() support __data_loc?
> 
> At 064739bc4b3d7f424b2f25547e6611bcf0132415 ,
> support for the modifier "__data_loc" of format is added.



I guess this patch handled the nature of the strings, but the current
end use is in perl. There is no support of it in raw_field_ptr().

Your patch looks good to me..

