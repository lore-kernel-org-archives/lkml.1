Return-Path: <linux-kernel-owner+w=401wt.eu-S1753569AbYKSNm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569AbYKSNm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 08:42:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752962AbYKSNmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 08:42:49 -0500
Received: from stag.SEAS.UPENN.EDU ([158.130.70.79]:47173 "EHLO
	stag.seas.upenn.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbYKSNms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 08:42:48 -0500
Message-ID: <492417D4.4090103@seas.upenn.edu>
Date: Wed, 19 Nov 2008 08:42:44 -0500
From: Rafi Rubin <rafi@seas.upenn.edu>
User-Agent: Mozilla-Thunderbird 2.0.0.17 (X11/20081018)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] n-trig digitizer quirks
References: <Pine.LNX.4.61.0811141207210.12963@minus.seas.upenn.edu> <alpine.LNX.1.10.0811181525490.19853@jikos.suse.cz> <49232910.2030309@seas.upenn.edu> <alpine.LNX.1.10.0811191355280.19853@jikos.suse.cz>
In-Reply-To: <alpine.LNX.1.10.0811191355280.19853@jikos.suse.cz>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1


> Could you please keep standard linux-kernel indenting style? I.e. 
> something like

Sorry, just had different settings in my vimrc for something else.

> 
> 
>> +
>> +static int ntrig_input_mapped(struct hid_device *hdev, struct hid_input *hi,
>> +		struct hid_field *field, struct hid_usage *usage,
>> +		unsigned long **bit, int *max)
>> +{
>> +	unsigned long quirks = (unsigned long)hid_get_drvdata(hdev);
> 
> This could be removed, as it is never used, right?

Yes, it wasn't used at the moment, just something left over from using hid-lg.c as a template.  Since this is the only device known for this driver at this point, is it better to keep it shorter and
not check for the duplicate usage from the driver data or would it be better to add the flexibility now?  Also, if you do prefer using driver data like that, is the probe function necessary to make it
work?

Rafi
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iEYEARECAAYFAkkkF9IACgkQwuRiAT9o6088RgCfdvu6ntRJ11vh5Ti2CHG+PJJz
SWcAoLrViuX6HO+wEaJnCS+Yt95nAr0D
=qepn
-----END PGP SIGNATURE-----
