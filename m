Return-Path: <linux-kernel-owner+w=401wt.eu-S1764698AbXESWtW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764698AbXESWtW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2007 18:49:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760844AbXESWtN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 May 2007 18:49:13 -0400
Received: from nz-out-0506.google.com ([64.233.162.230]:9944 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759543AbXESWtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2007 18:49:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:references;
        b=LX5l+wnuBfFffgm6puWB6a4hEkhgfs3QBJu48Q1HDJJoJlP21TFXWI8gC5TPelwAgijb8rjuZHck+xQA4QhBbxeiQaJrW4MPQYN5ceqdTwKRXYL3NJd8rcbMciWwmdOFuGvQYJt0dpcQwP9rURUG+ig7FKkEimIFJVSjn4NVGX4=
Message-ID: <2e4afe1e0705191549w68992907p74c8b6310da2a33a@mail.gmail.com>
Date: Sun, 20 May 2007 04:19:10 +0530
From: "Karuna sagar K" <karunasagark@gmail.com>
To: suparna@in.ibm.com
Subject: Re: ChunkFS - measuring cross-chunk references
Cc: "Theodore Tso" <tytso@mit.edu>, "Kalpak Shah" <kalpak@linsyssoft.com>,
       "Amit Gud" <gud@ksu.edu>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, val_henson@linux.intel.com
In-Reply-To: <20070425102342.GA26179@in.ibm.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; 
	boundary="----=_Part_75191_7878007.1179614950193"
References: <2e4afe1e0704221335y6d4c84d8id65e71826ce60acb@mail.gmail.com>
	 <462B8D0C.7020509@ksu.edu>
	 <2e4afe1e0704230019h3853bc82uae6c9b5cdc325ab9@mail.gmail.com>
	 <1177320876.23226.7.camel@garfield>
	 <20070423205333.GZ5967@schatzie.adilger.int>
	 <20070424001306.GB1663@thunk.org>
	 <2e4afe1e0704241717l6e6ec72by898727b5973c221@mail.gmail.com>
	 <2e4afe1e0704241720q3eb54e24gcd10b2026759333@mail.gmail.com>
	 <20070425102342.GA26179@in.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

------=_Part_75191_7878007.1179614950193
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On 4/25/07, Suparna Bhattacharya <suparna@in.ibm.com> wrote:
> On Wed, Apr 25, 2007 at 05:50:55AM +0530, Karuna sagar K wrote:
>
> One more set of numbers to calculate would be an estimate of cross-references
> across chunks of block groups -- 1 (=128MB), 2 (=256MB), 4 (=512MB), 8(=1GB)
> as suggested by Kalpak.
>

Here is the tool to make such calculations.

Result of running the tool on / partition of ext3 file system (each
chunk is 4 times a block group):

./cref.sh /dev/hda1 dmp /mnt/test 4

-------------------------------------------------------

Number of files = 221763

Number of directories = 24456

Total size = 8193116 KB

Total data stored = 7179200 KB

Size of block groups = 131072 KB

Number of inodes per block group = 16288

Chunk size = 524288 KB

No. of cross references between directories and sub-directories = 869

No. of cross references between directories and file = 584

Total no. of cross references = 13806 (dir ref = 1453, file ref = 12353)

-------------------------------------------------------


> Once we have that, it would be nice if we can get data on results with
> the tool from other people, especially with larger filesystem sizes.
>


Thanks,
Karuna

------=_Part_75191_7878007.1179614950193
Content-Type: application/x-bzip2; name=cref.tar.bz2
Content-Transfer-Encoding: base64
X-Attachment-Id: f_f1wnrlpx
Content-Disposition: attachment; filename="cref.tar.bz2"

QlpoOTFBWSZTWdr1/IMAB9P/lNywAEB////fv6/erv////4BAAAAgAhgCv88Pfd3YfX2Z77q4Nml
5tvO+++OtAHoBQDJhkiI8qaek9I/SjQDRpo9IA0GmyIyAAAAzUAlCAIJpPRBqDQDTQDamgANABoa
ANABpkSk9E0GgAyAAAAA0AAGgADQCFSUm1NDQNGhoAAAAaAAAAAAAEUk9TVT8qP1J6nqeU9Rpo9J
oaHkgAAaAADQAAAiUQCZCaaGkxNTxR6FPaKaYCDIDQHpNDTynlDTT7g+v+P15dHS9n4GAS2KhMRV
ev3rjaaztrJQbA4u6z39AyQxScgRVKg1RMxQkhJGEKpSmIiaUpqIggKqkmAiSmJWhiWKqmoooqQq
WIiKImqommBlIilhJIkYIgoqUhCSCGF3HG/MK6r5ZJMxCmQnOyd3ZwxnMmEF1KUMBCIeIILFKMEF
pDUgmCYmYGgFWCIkrX4Qy2QKF9lGtsrC6zGtskqwmMKxqyLMKNIplgwpoCE5pKAoiIaqCaKiz6EV
rw5tOVgIrzT4TUCzT63l2CRNQsajouCSWpnrajmhWSEhxBA4Bzh7AsX/pwX4R9ZAPUd/Hb7DE1k5
Dyem0qcPhShp1Wmrqspn9C/LFoBOIG9Pafdeh7oXRWes3eopsJVkx33lbVvDzBL/7e21Pnm1Nle7
xd2y/29dUj2PPsDpIhwILuI41X6eRPdZjoQ4S+1NxS5UVQzLFmqMMuHuFaeJENBtjA+0mOtxCodO
b3jYVlpTlLZ2Q1QlTDHQ5PeDmT76sJdREW2I4svIE6ElQ1RQgStpIldSlhTy89H6Ahcx+Ali0d5i
aDqvoauxsWpqoRmc1WFTFmW6N44IFVjsswg9RWWWZ7jjLlrKQHHyxsyi1MXYo6MUqucFeoImtFm/
PTfZnxz9rrb2F/Myoy2yxxsv2tC0zCh7uYrkuuhQ0vah/rROk8npQ9XdYvGHVz3JSFKDywAyXyCQ
EiXjP901LJNqEq/iAM8ihQxa2xqxKZ3MsIlGjtFqGoS6M619FJJqUCAFhbYDnihDKo6OyUcEQmSc
4UppODI9AneGCw7Jbbm1T5QHZNExBpKSslCZ+1xr8zwLcGbaHBLY62iqi0waeotMWybjRCF8ZOAV
8VoqD2JRgQ9t3rw3r91l0+q3VRrXLNZNhnXfhxHbbuI47qnXAkXmfmOFp054HXWpCXo4HFtDjQv4
e22yYLxlVleY3b3i13lS6FCcUaRkKzfhfWlgZ1JlUrsA7D4woHFe0dCWHvLRD/kXk8tKFKDe5HgQ
8+h9XJj5ScWOct+LBDw0EzOY6uu7l+3dU/9m5POAeijosR5CwEgB+tOjt9EH1EBpC9C9AvPXhrzs
AbSDIm6EqgqcG9wW/BaiYV98gv5krAwBQbLSiHQmxCgWEZEXhYEapWVPJHMVgOJsxIMo+QQrOoY3
ll9x4/JtO17Dd6Pj9tfQSG9O8+SEgEllKKwiApeKrOdTO83ucMOJCssRhBlkqIdMrpyOax/XiabG
RlSozGoqza+659IEVFLrVFasVGFSou3CptUD4FPBaIFKEKCuhoW5eUlouZZWik3AC8Zweqkpwi1f
vmQDtOzx4KoRJ6eYxRZvPrCuQTUrr7WIEQumGI3AI4gyuBAZ6yWNAaFC0whodelImc5u/rWqYXoY
oXaK4kDNSATzut9G6rRJkm1EunPO5GuQ5ecrNupr94dpEr+ICF6/fl+Y4g+R8B9JQJeiGHoGEI7O
6sCSWSX8uUuAbWiawVRJxyRAckBCQLdtAhVRUVg84RFAVREGFOoFMBk1BFUUKZ2zdKzVp9dd+Ghl
/NEftvo62e8JE+2mFMRCjEg7gDAdEDf34J4hVFTWq7X2uHsQSwVJUUF4Eb2sFJIkjnAuEmiUhJQC
9IERAEPBiGcjNi41PZjiwvKm5Gtc7lVyhWyzhMXNQucVAnotKIUGuyxpANpQyXbTEtMgc1MhDt13
1G6zgQlS4s5KiEpNv7On8LXoDabwKp7vnSuvYTcdS8dqLKm6DaFPFzFcLJNUkl6nsWCUHrEZjl+w
TAEwSVprzQaYoULpDn1gRc5UjC8uHIt2wD2X9A9Fk+zvSef38tQP8i2WaX9VloyFbm4Z01qZiS2w
ily7AyEOGWKIYIuBQCD/GpYAGv4MjEMZn5mw24MCFizFA10TktDzMFPG5b5hwK8JcuM2dZyQoYFn
Pa3I5lrq6oB7nVuNs0EYUSCUfGuaDPHl0EwDdhQpCUSEJQlpVtWBDVdLqEnq377LZMUpg5UODXfU
iQkujdSgkCmcKDxTbaeMx9Pk60uiK82GPadLzIv5+dNYeZdoTEIBUgPLwkoZgHabOjzg9YFHuKIf
rgIZPYBiGhpFTg5ovTeh3EU6+kuw4dvGp6wbjO4b8+knIb9t2QScxSTExOy5BvOPhh47KimnrE1v
zQdDAgfjMi+ETnCS3Rk4iQJoKIlWGaprTLOIcglWL16NKK2xdLV4cAAKd6x8FeGJ+q5hNii9IGab
Brz7jHEciIXgzZfzzZsdglaLa9AXdDrtrhx11KUQaca3PiHKLQ9YDK0JpRQ6aqeBoM2XtgN5kpQS
VN1yLgIWhGEBCSWFoKZVkCQMKU/fYgFqENbCxJJQYSErAoRhURvK96WoFjcvYYTozYD9ZLuVCGLU
0XLn8914i6EQzQ14DQDoi1aShAocqZwLktbQN0+xtW9TEMCKQzCaKWaTS1mFsEpgpkCIJKLCDKpX
U8iJXYB/i5be5sAdWGaZmfMG5iZ6ylhUhIw3RqRSgEJJBsLBS9AzHVJcBd/XNdQXEVI4NzuTHFHU
gZBXNB0R0DLwD8ApVA0dQA6IfzWIZKGqLAh2G2zSPxwZ5GWy2zla2D9viHJh6d/Si2G4wkZ31dV6
8oWmJDz/KUDBh4qd5XoCpQi0KVi0CUDM6zMishQmgHIGxHWkNWumog85O2YzmhlacZXFCFIRJsIt
GdcKsXSN9y1o0EbZQZ5bFCL6Rhv1MiwHUuL6gZ1uSwVhAyq5siBNoUBtNKmJdl4y49BKn0dHlUTc
cRem8gkhQo3omydqPxBvTbrQi720wOqou9DnIjbqFegS9F1hrH2kMZIs8dVP+LuSKcKEhtev5Bg=

------=_Part_75191_7878007.1179614950193--
