Return-Path: <linux-kernel-owner+w=401wt.eu-S1757518AbYFLSGg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757518AbYFLSGg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 14:06:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753777AbYFLSG2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 14:06:28 -0400
Received: from E23SMTP05.au.ibm.com ([202.81.18.174]:40121 "EHLO
	e23smtp05.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753702AbYFLSG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 14:06:27 -0400
Date: Thu, 12 Jun 2008 23:36:05 +0530
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Holger Kiehl <Holger.Kiehl@dwd.de>
Cc: Theodore Tso <tytso@mit.edu>, Solofo.Ramangalahy@bull.net,
       Nick Dokos <nicholas.dokos@hp.com>, linux-ext4@vger.kernel.org,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Performance of ext4
Message-ID: <20080612180605.GD22481@skywalker>
References: <Pine.LNX.4.64.0806110801370.19793@diagnostix.dwd.de> <20080611105945.GB9008@skywalker> <Pine.LNX.4.64.0806111937460.3720@diagnostix.dwd.de> <18563.1213215457@alphaville.zko.hp.com> <Pine.LNX.4.64.0806120855370.27806@diagnostix.dwd.de> <18513.345.553912.449710@frecb006361.adech.frec.bull.fr> <Pine.LNX.4.64.0806121154090.27806@diagnostix.dwd.de> <20080612131928.GB18229@mit.edu> <Pine.LNX.4.64.0806121333480.27806@diagnostix.dwd.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0806121333480.27806@diagnostix.dwd.de>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 02:07:30PM +0000, Holger Kiehl wrote:
> This time there is no OOPS and system is still up running without any
> problem (except any process wanting to write something to this filesystem
> gets stuck forever).
>
> What can I do to help find the problem? The system is still up with all those
> process hanging in D-state.
>

if you can login to the system get the dmesg output after

echo t > /proc/sysrq-trigger


-aneesh
