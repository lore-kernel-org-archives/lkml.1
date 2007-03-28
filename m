Return-Path: <linux-kernel-owner+w=401wt.eu-S965587AbXC1Sl1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965587AbXC1Sl1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2007 14:41:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965647AbXC1Sl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Mar 2007 14:41:27 -0400
Received: from smtp003.mail.ukl.yahoo.com ([217.12.11.34]:48639 "HELO
	smtp003.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S965587AbXC1Sl0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2007 14:41:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.it;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=ZMi4sL/TogLQmMzg1EWsM9TWez/4vKTnu63N/v06tqcLwDrs54o4EhGayMM0nxFqn6H842qR49cC1F7/WV6QQ0esRNhypSv/QLHHI5TwzuegCGNm4VnNOvfM607dispVHT3GFmSe3DcV9ArmNJlqeqv1px8c0nOEnXM2Peb5cnc=  ;
X-YMail-OSG: DZtI3VIVM1lZF3o9pwfBJtxQ68iywZ6USfeYRSp_L5W8MehqENl9DQ_z2Gc.nwwwNMGi2qVQjsSIgJIRXLM2Pg.ohcO2o_t94y7xFH0UTRrnrSCL34i.U.uY.Mgju_tqi4mcPmeb9t9q5CN.Fb2mYA--
From: Blaisorblade <blaisorblade@yahoo.it>
To: akpm@linux-foundation.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: + uml-fix-pte-bit-collision.patch added to -mm tree
Date: Wed, 28 Mar 2007 20:41:14 +0200
User-Agent: KMail/1.9.6
Cc: mszeredi@suse.cz, jdike@linux.intel.com
References: <200703272032.l2RKWWSe027097@shell0.pdx.osdl.net>
In-Reply-To: <200703272032.l2RKWWSe027097@shell0.pdx.osdl.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200703282041.14828.blaisorblade@yahoo.it>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On martedì 27 marzo 2007, akpm@linux-foundation.org wrote:
> The patch titled
>      uml: fix pte bit collision
> has been added to the -mm tree.  Its filename is
>      uml-fix-pte-bit-collision.patch

ACK from me:

Acked-by: Paolo 'Blaisorblade' Giarrusso <blaisorblade@yahoo.it>

> *** Remember to use Documentation/SubmitChecklist when testing your code
> ***
>
> See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
> out what to do about this

> ------------------------------------------------------
> Subject: uml: fix pte bit collision
> From: Miklos Szeredi <mszeredi@suse.cz>
>
> _PAGE_PROTNONE conflicts with the lowest bit of pgoff.  This causes all
> sorts of weirdness when nonlinear mappings are used.

Hmm, I had unit-tested to death the code with a custom test-program...
The interesting thing is that I only tested my remap_file_pages changes (which 
are unaffected by this), not the existing code...
-- 
Inform me of my mistakes, so I can add them to my list!
Paolo Giarrusso, aka Blaisorblade
http://www.user-mode-linux.org/~blaisorblade
