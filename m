Return-Path: <linux-kernel-owner+w=401wt.eu-S1758227AbXFUUJd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758227AbXFUUJd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2007 16:09:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755140AbXFUUJY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jun 2007 16:09:24 -0400
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:38007 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138AbXFUUJX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2007 16:09:23 -0400
To: Neil Brown <neilb@suse.de>
Cc: David Chinner <dgc@sgi.com>, Avi Kivity <avi@argo.co.il>, david@lang.hm,
       linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: Re: limits on raid
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm>
	<18034.479.256870.600360@notabene.brown>
	<Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm>
	<18034.3676.477575.490448@notabene.brown>
	<467273AB.9010202@argo.co.il>
	<18035.3009.568832.785308@notabene.brown>
	<20070618045759.GD85884050@sgi.com>
	<18041.59628.370832.633244@notabene.brown>
From: Nix <nix@esperi.org.uk>
Emacs: more than just a Lisp interpreter, a text editor as well!
Date: Thu, 21 Jun 2007 21:08:54 +0100
In-Reply-To: <18041.59628.370832.633244@notabene.brown> (Neil Brown's message of "21 Jun 2007 03:57:09 +0100")
Message-ID: <87d4zp1355.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1007 (Gnus v5.10.7) XEmacs/21.5-b27 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-CTc-dcc2-Metrics: hades 1031; Body=6 Fuz1=6 Fuz2=6
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 21 Jun 2007, Neil Brown stated:
> I have that - apparently naive - idea that drives use strong checksum,
> and will never return bad data, only good data or an error.  If this
> isn't right, then it would really help to understand what the cause of
> other failures are before working out how to handle them....

Look at the section `Disks and errors' in Val Henson's excellent report
on last year's filesystems workshop: <http://lwn.net/Articles/190223/>.
Most of the error modes given there lead to valid checksums and wrong
data...

(while you're there, read the first part too :) )

-- 
`... in the sense that dragons logically follow evolution so they would
 be able to wield metal.' --- Kenneth Eng's colourless green ideas sleep
 furiously
